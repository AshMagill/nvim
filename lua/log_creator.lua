local M = {}
local function get_current_date()
    return os.date("%Y-%m-%d_%H-%M-%S")
end
local function create_log_file(category, title)
    local date = get_current_date()
    local filename = date .. "_" .. title:gsub("%s+", "_") .. ".txt"
    local path = ""
    if category:find("Workflow") then
        local workflow_path = "/home/ash/Documents"
        local workflow_dirs = vim.fn.readdir(workflow_path)
        path = workflow_path .. "/" .. category .. "/Logs/" .. filename
    elseif category:find("Workspace") then
        local workspace_path = "/home/ash"
        local workspace_dirs = vim.fn.readdir(workspace_path)
        path = workspace_path .. "/" .. category .. "/Logs/" .. filename
    end
    local file = io.open(path, "w")
    if file then
        file:close()
        print("Log file created: " .. path)
        vim.cmd("vsplit " .. path) -- Open the new log file in another pane
    else
        print("Error creating log file: " .. path)
    end
end
function M.create_log()
    local categories = {"Workflow", "Workspace"}
    vim.ui.select(categories, {prompt = 'Select a category:'}, function(choice)
        if choice then
            local path = ""
            if choice == "Workflow" then
                path = "/home/ash/Documents/Workflow"
            elseif choice == "Workspace" then
                path = "/home/ash/Workspace"
            end
            local dirs = vim.fn.readdir(path)
            local subfolders = {}
            for _, dir in ipairs(dirs) do
                table.insert(subfolders, choice .. "/" .. dir)
            end
            vim.ui.select(subfolders, {prompt = 'Select a subfolder:'}, function(subfolder)
                if subfolder then
                    vim.ui.input({prompt = 'Enter the title of the log:'}, function(title)
                        if title then
                            create_log_file(subfolder, title)
                        else
                            print("Log creation cancelled.")
                        end
                    end)
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

