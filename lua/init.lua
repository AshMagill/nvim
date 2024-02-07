require('plugins')
require('mason-config')
require('custom-keys')
require('debugging')
require('file-finder')
require('auto-install')
require('parsers')
require('intergrated-terminal')
require('local-ai')
require('chat-gpt')
--require('hardtime').setup()

-- new folder
   local folder_creator = require('folder_creator')
   -- Add a Neovim command that calls the create_folder function
   vim.api.nvim_create_user_command('CreateFolder', folder_creator.create_folder, {})
   -- You can also set up a keybinding if you prefer
   vim.api.nvim_set_keymap('n', '<leader>eln', ':CreateFolder<CR>', { noremap = true, silent = true })

--list logs
   local log_filter = require('log_filter')
   -- Add a Neovim command that calls the create_log function
   vim.api.nvim_create_user_command('GetLogs', log_filter.getLogs, {})
   -- You can also set up a keybinding if you prefer
   vim.api.nvim_set_keymap('n', '<leader>cll', ':GetLogs<CR>', { noremap = true, silent = true })

--create logs
   local log_creator = require('log_creator')
   -- Add a Neovim command that calls the create_log function
   vim.api.nvim_create_user_command('CreateLog', log_creator.create_log, {})
   -- You can also set up a keybinding if you prefer
   vim.api.nvim_set_keymap('n', '<leader>cln', ':CreateLog<CR>', { noremap = true, silent = true })

--list todos
   local todo_list = require('todo_list')
vim.api.nvim_create_user_command('ListTodos', todo_list.list_todo, {})
vim.api.nvim_set_keymap('n', '<leader>dll', ':ListTodos<CR>', {noremap= true})

--delete todos
   local todo_delete= require('todo_delete')
vim.api.nvim_create_user_command('DeleteTodos', todo_delete.list_todo, {})
vim.api.nvim_set_keymap('n', '<leader>dld', ':DeleteTodos<CR>', {noremap= true})

--create todos
   local todo_create = require('todo_create')
vim.api.nvim_create_user_command('CreateTodos', todo_create.create_todo, {})
vim.api.nvim_set_keymap('n', '<leader>dln', ':CreateTodos<CR>', {noremap= true})


