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
-- Function to write a table to a CSV file
local function write_csv(file_path, lines)
    local file = io.open(file_path, "a") -- Open the file in append mode
    for _, fields in ipairs(lines) do
        file:write(table.concat(fields, ",") .. "\n")
    end
    file:close()
end
-- Function to prompt the user for todo details
local function prompt_todo_details()
    local path_options = {
        "/home/ash/Documents/Workflow",
        "/home/ash/Workspace"
    }
    local numbered_options = {}
    for i, path in ipairs(path_options) do
        table.insert(numbered_options, i .. ". " .. path)
    end
    local choice = vim.fn.inputlist(numbered_options)
    local subfolder_path = path_options[choice]
       vim.api.nvim_out_write("\n") -- Add a line break    
 
    local subfolders = vim.fn.globpath(subfolder_path, "*", 1, 1)
    local subfolder_options = {}
    for i, subfolder in ipairs(subfolders) do
        table.insert(subfolder_options, i .. ". " .. subfolder)
    end
    local subfolder_choice = vim.fn.inputlist(subfolder_options)
    local selected_subfolder = subfolders[subfolder_choice]
    
        vim.api.nvim_out_write("\n") -- Add a line break    

    local name = vim.fn.input("Enter the name of the todo: ")
    local description = vim.fn.input("Enter the description of the todo: ")
    local urgency = vim.fn.input("Enter the urgency of the todo: ")
    
    return selected_subfolder, name, description, urgency
end

-- Function to create a new todo
function M.create_todo()
    local subfolder_path, name, description, urgency = prompt_todo_details()
    local todo_file = subfolder_path .. "/Todo/todo.csv"
    local todo_lines = read_csv(todo_file)
    
    -- Check if the todo name already exists
    for i, line in ipairs(todo_lines) do
        if line[1] == name then
            print("Todo with the same name already exists.")
            return
        end
    end    
    -- Generate the date and time
    local date = os.date("%Y-%m-%d")
    local time = os.date("%H:%M:%S")
    
    -- Create a new todo line with date and time
    local new_todo = {name, description, date .. " " .. time, urgency}
    
    -- Write the new todo line to the CSV file
    write_csv(todo_file, {new_todo})
    
    print("Todo created successfully.")
end


return M

