local M = {}
local function create_directories(base_path, folder_name, subfolders)
    local full_path = base_path .. folder_name
    os.execute("mkdir -p " .. full_path)
    for _, subfolder in ipairs(subfolders) do
        os.execute("mkdir -p " .. full_path .. "/" .. subfolder)
        if subfolder == "Todo" then
            local csv_file_path = full_path .. "/" .. subfolder .. "/todo.csv"
            os.execute("touch " .. csv_file_path)
            local csv_file = io.open(csv_file_path, "w")
            csv_file:write("name,description,time-date,urgency\n") -- Add the header line
            csv_file:close()
        elseif subfolder == "Links" then
            local csv_file_path = full_path .. "/" .. subfolder .. "/links.csv"
            os.execute("touch " .. csv_file_path)
            local csv_file = io.open(csv_file_path, "w")
            csv_file:write("url,name,description,time-date\n") -- Add the header line
            csv_file:close()
        end
    end
end
local function add_bookmark(folder_name)
    local bookmarks_path = "/home/ash/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
    local bookmarks_file = io.open(bookmarks_path, "r")
    if bookmarks_file then
        local bookmarks_data = bookmarks_file:

read("*all")
        bookmarks_file:close()
        local bookmarks = vim.fn.json_decode(bookmarks_data)
        if bookmarks then
            -- Create the new folder entry
            local new_folder = {
                children = {},
                date_added = tostring(os.time()),
                date_last_used = "0",
                date_modified = tostring(os.time()),
                guid = tostring(os.time()),
                id = tostring(os.time()),
                name = folder_name,
                type = "folder"
            }
            -- Add the new folder to the bookmark_bar
            bookmarks.roots.bookmark_bar.children[#bookmarks.roots.bookmark_bar.children + 1] = new_folder
            -- Convert the modified bookmarks table back to JSON
            local updated_bookmarks = vim.fn.json_encode(bookmarks)
            -- Write the updated bookmarks data back to the file
            local updated_bookmarks_file = io.open(bookmarks_path, "w")
            updated_bookmarks_file:write(updated_bookmarks)
            updated_bookmarks_file:close()
        else
            print("Failed to parse bookmarks data.")
        end
    else
        print("Failed to open bookmarks file.")
    end
end
function M.create_folder()
    local categories = {"Workflow", "Workspace"}
    vim.ui.select(categories, {prompt = 'Select a category (Workflow/Workspace):'}, function(category)
        if category then
            vim.ui.input({prompt = 'Enter the Folder Name:'}, function(folder_name)
                if folder_name
then
                    local base_path
                    local subfolders
                    if category == "Workflow" then
                        base_path = "/home/ash/Documents/Workflow/"
                        subfolders = {"Logs", "Todo", "Links"}
                    else
                        base_path = "/home/ash/Workspace/"
                        subfolders = {"Docs", "Learning", "Logs", "Todo", "Source", "Queries", "Templates", "Links"}
                    end
                    create_directories(base_path, folder_name, subfolders)
                    add_bookmark(folder_name)
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

