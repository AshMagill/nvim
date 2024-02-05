local M = {}
local function get_current_date()
    return os.date("%Y-%m-%d_%H-%M-%S")
end
local function create_log_file(category, title)
    local date = get_current_date()
    local filename = date .. "_" .. title:gsub("%s+", "_") .. ".txt"
    local path = ""
    
    if category:find("Workspace") then
        path = "/home/ash/" .. category .. "/Logs/" .. filename
    else
        path = "/home/ash/Documents/" .. category .. "/Logs/" .. filename
    end
    
    local file = io.open(path, "w")
    if file then
        --file:write("-- Log created on " .. date .. " --\n\n")
        file:close()
        print("Log file created: " .. path)
        vim.cmd("edit " .. path)
    else
        print("Error creating log file: " .. path)
    end
end
function M.create_log()
    local log_directories = {
        Workflow = {},
        Workspace = {}
    }
    
    -- Read log directories from the file system
    local workflow_path = "/home/ash/Documents/Workflow"
    local workspace_path = "/home/ash/Workspace"
local workflow_dirs = vim.fn.readdir(workflow_path)
    local workspace_dirs = vim.fn.readdir(workspace_path)
    
    -- Populate log_directories table with directories from the file system
    for _, dir in ipairs(workflow_dirs) do
        table.insert(log_directories.Workflow, dir)
    end
    
    for _, dir in ipairs(workspace_dirs) do
        table.insert(log_directories.Workspace, dir)
    end
    
    local categories = {}
    
    for workspace, dirs in pairs(log_directories) do
        for _, dir in ipairs(dirs) do
            table.insert(categories, workspace .. "/" .. dir)
        end
    end
    
    vim.ui.select(categories, {prompt = 'Select a category:'}, function(choice)
        if choice then
            vim.ui.input({prompt = 'Enter the title of the log:'}, function(title)
                if title then
                    create_log_file(choice, title)
                else
                    print("Log creation cancelled.")
                end
            end)
        else
            print("Log creation cancelled.")
        end
    end)
end
return M

