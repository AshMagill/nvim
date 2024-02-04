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
                    if category == "Workflow" then
                        base_path = "/home/ash/Documents/Workflow/"
                    else
                        base_path = "/home/ash/Workplace/" -- Changed base path for Workspace
                    end
                    local subfolders = category == "Workflow"
                        and {"Logs", "Todo"} or {"Docs", "Learning", "Logs", "Todo", "Source", "Queries", "Templates"}
                    create_directories(base_path, folder_name, subfolders)
                    -- Update log_creator.lua to include the new folder
                    local log_creator_path = "/home/ash/.config/nvim/lua/log_creator.lua"
                    local log_creator_file = io.open(log_creator_path, "a") -- Open for appending
                    if log_creator_file then
                        local new_entry = string.format('           "%s",\n', folder_name)
                        local category_key = category == "Workflow" and "Workflow" or "Workspace"
                        local lines = {}
                        for line in io.lines(log_creator_path) do
                            if line:match('"' .. category_key .. '"') then
                                table.insert(lines, line)
                                table.insert(lines, new_entry)
                            else
                                table.insert(lines, line)
                            end
                        end
                        log_creator_file:close()
                        -- Rewrite the log_creator.lua file with the new entry
                        log_creator_file = io.open(log_creator_path, "w")
                        for _, line in ipairs(lines) do
                            log_creator_file:write(line .. "\n")
                        end
                        log_creator_file:close()
                        print("Folder and log entry created successfully.")
                    else
                        print("Error: Unable to open log_creator.lua for updating.")
                    end
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


