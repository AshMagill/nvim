local M = {}
local function create_directories(base_path, folder_name, subfolders)
    local full_path = base_path .. folder_name
    os.execute("mkdir -p " .. full_path)
    for _, subfolder in ipairs(subfolders) do
        os.execute("mkdir -p " .. full_path .. "/" .. subfolder)
    end
end
function M.create_folder()
    local categories = {"Workflow", "Workspace"}
    vim.ui.select(categories, {prompt = 'Select a category (Workflow/Workspace):'}, function(category)
        if category then
            vim.ui.input({prompt = 'Enter the Folder Name:'}, function(folder_name)
                if folder_name then
                    local base_path
                    local subfolders
                    if category == "Workflow" then
                        base_path = "/home/ash/Documents/Workflow/"
                        subfolders = {"Logs", "Todo"}
                    else
                        base_path = "/home/ash/Workspace/"
                        subfolders = {"Docs", "Learning", "Logs", "Todo", "Source", "Queries", "Templates"}
                    end
                    create_directories(base_path, folder_name, subfolders)
                    print("Folder created successfully.")
                else
                    print("Folder creation cancelled.")
                end
            end)
        else
            print("Folder creation cancelled.")
        end
    end)
end
return M

