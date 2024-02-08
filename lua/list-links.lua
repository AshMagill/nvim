local M = {}
-- Function to read a CSV file and return its contents as a table
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
local function open_link(url)
    local command = "qutebrowser " .. url
    os.execute(command)
end
-- Function to handle the workflow
function M.list_links()
    -- Prompt the user to choose between Workflow and Workspace
    local folder_choice = vim.fn.input("Choose a folder:\n1. Workflow\n2. Workspace\n")
    vim.api.nvim_out_write("\n")
    
    -- Set the path of the Workflow folder based on the user's choice
    local workflow_path =""
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
    
    -- Prompt the user to select a link to open
    local options = {}
    for i, line in ipairs(links_lines) do
        table.insert(options, i .. ". " .. line[2]) -- Assuming the name is in the second column
    end
    table.insert(options, "0. Exit")
    
    local open_choice = vim.fn.inputlist(options)
    vim.api.nvim_out_write("\n")
    
    if open_choice == 0 then
        vim.api.nvim_out_write("Exiting...\n")
        return
    end    
    -- Get the selected link entry
    local selected_entry = links_lines[open_choice]
    
    -- Open the link in the default browser
    open_link(selected_entry[1]) -- Assuming the URL is in the first column    
    vim.api.nvim_out_write("Link opened successfully.\n")
end
return M

