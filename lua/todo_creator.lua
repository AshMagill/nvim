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
-- Function to prompt the user for sorting options
local function prompt_sort_options()
    local options = {
        "Sort by Date Created",
        "Sort by Urgency"
    }
    -- Create a numbered list of sorting options
    local numbered_options = {}
    for i, option in ipairs(options) do
        table.insert(numbered_options, i .. ". " .. option)
    end
    local choice = vim.fn.inputlist(numbered_options)
    -- Restoring the original choice index
    choice = tonumber(choice)
    return choice
end
-- Function to handle the workflow
function M.handle_workflow()
    -- Specify the absolute path of the Workflow folder
    local workflow_path = "/home/ash/Documents/Workflow"
    -- Get a list of all subfolders in the Workflow folder
    local subfolders = vim.fn.globpath(workflow_path, "*", 1, 1)
    -- Prompt the user to select a subfolder or select all subfolders
    local numbered_options = {}
    for i, subfolder in ipairs(subfolders) do
        table.insert(numbered_options, i .. ". " .. subfolder)
    end
    local choice = vim.fn.inputlist(numbered_options)
    -- Create a buffer to display the todos
    vim.cmd("enew")
    local bufnr = vim.api.nvim_get_current_buf()
    -- Read the todo.csv file(s) based on the user's choice
    local todo_lines = {}
    if choice == #subfolders + 1 then
        -- Concatenate all todo.csv files into one buffer
        for _, subfolder in ipairs(subfolders) do
            local todo_file = subfolder .. "/Todo/todo.csv"
            local lines = read_csv(todo_file)
            for _, line in ipairs(lines) do
                table.insert(todo_lines, line)
            end
        end
    else
        -- Read the selected subfolder's todo.csv file
        local todo_file = subfolders[choice] .. "/Todo/todo.csv"
        todo_lines = read_csv(todo_file)
    end
    -- Sort the todo lines based on the user's choice
    local sort_choice = prompt_sort_options()
    if sort_choice == 1 then
        table.sort(todo_lines, function(a, b)
            return a[3] > b[3]
        end)
    elseif sort_choice == 2 then
        table.sort(todo_lines, function(a, b)
            return tonumber(a[4]) < tonumber(b[4])
        end)
    end
    -- Clear the buffer and display the sorted todo lines
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
for _, line in ipairs(todo_lines) do
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, line)
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {""}) -- Add an empty line after each line
end


    -- Set the buffer options
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(bufnr, "filetype", "todo")
    -- Switch to the todo buffer
    vim.cmd("buffer " .. bufnr)
end
return M

