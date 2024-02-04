   local M = {}
   local log_directories = {
       Workflow = {
           "Linux", "Networking", "Docker", "Devops", "BSD",
           "Virtualization", "Datasets", "Debugging", "Databases"
       },
       Workspace = {
           "Mernrod", "rwg", "Ecommerce", "Chatscreen"
, "Gusn" 
       }
   }
   local function get_current_date()
       return os.date("%Y-%m-%d_%H-%M-%S")
   end
   local function create_log_file(category, title)
       local date = get_current_date()
       local filename = date .. "_" .. title:gsub("%s+", "_") .. ".txt"
       local path = "/home/ash/Documents/" .. category .. "/Logs/" .. filename
       local file = io.open(path, "w")
       if file then
           file:write("-- Log created on " .. date .. " --\n\n")
           file:close()
           print("Log file created: " .. path)
           vim.cmd("edit " .. path)
       else
           print("Error creating log file: " .. path)
       end
   end
   function M.create_log()
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

