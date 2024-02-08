local M = {} -- Function to read a CSV file and return its contents as a table
local function read_csv(file_path)
    local file = io.open(file_path, "r")
    local lines = {}
    local isFirstLine = true
    for line in file:lines() do
        if not isFirstLine then
            local fields = {}
            for value in line:gmatch("[^,]+") do
                table.insert(fields, value)
            end
            table.insert(lines, fields)
        else
            isFirstLine = false
        end
    end
    file:close()
    return lines
end
-- Function to write a table to a CSV file
local function write_csv(file_path, lines)
    local file = io.open(file_path, "w")
    file:write("url,name,description,time-date\n") -- Add the header line
    for _, fields in ipairs(lines) do
        file:write(table.concat(fields, ",") .. "\n")
    end
    file:close()
end
-- Function to prompt the user for deletion options
local function prompt_delete_options(links_lines)
    local options = {}
    for i, line in ipairs(links_lines) do
        table.insert(options, i .. ". " .. line[2]) -- Assuming the name is in the second column
    end    
    table.insert(options, "0. Exit") -- Add an option to exit    
    local choice = nil
while not choice do
        choice = vim.fn.inputlist(options)
        choice = tonumber(choice)
        
        if choice == 0 then
            return nil -- Return nil to indicate exit
        elseif not choice or choice > #links_lines then
            vim.api.nvim_out_write("Invalid choice. Please try again.\n")
            choice = nil
        end
    end    
    return choice
end
-- Function to handle the workflow
function M.list_links()
    -- Prompt the user to choose between Workflow and Workspace
    local folder_choice = vim.fn.input("Choose a folder:\n1. Workflow\n2. Workspace\n")
    vim.api.nvim_out_write("\n")
    
    -- Set the path of the Workflow folder based on the user's choice
    local workflow_path = ""
    if folder_choice == "1" then
        workflow_path = "~/Documents/Workflow"
    elseif folder_choice == "2" then
        workflow_path = "~/Workspace"
    else
        vim.api.nvim_out_write("Invalid choice. Exiting...\n")
        return
    end    
    -- Get a list of all subfolders in the Workflow folder
    local subfolders = vim.fn.globpath(workflow_path, "*", 1, 1)

    -- Prompt the user to select a subfolder
local numbered_options = {}
for i, subfolder in ipairs(subfolders) do
    table.insert(numbered_options, i .. ". " .. subfolder)
end
local choice = vim.fn.inputlist(numbered_options)
vim.api.nvim_out_write("\n")
    -- Read the links.csv file of the selected subfolder
    local links_file = subfolders[choice] .. "/Links/links.csv"
    local links_lines = read_csv(links_file)
    
    local exit = false
    while not exit do
        -- Prompt the user to select a link entry to delete
        local delete_choice = prompt_delete_options(links_lines)
       
        if delete_choice then
            if delete_choice == 0 then
                exit = true
                vim.api.nvim_out_write("Exiting...\n")
            else
                -- Get the selected link entry
                local selected_entry = links_lines[delete_choice]
                
                -- Remove the selected entry from the table
                table.remove(links_lines, delete_choice)
                
                -- Write the updated table back to the file
                write_csv(links_file, links_lines)
                
                vim.api.nvim_out_write("Entry deleted successfully.\n")
            end
        else
            exit = true
            vim.api.nvim_out_write("Exiting...\n")
        end
    end
end
return M
