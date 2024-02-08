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

  --                     PRIME CONFIG                        -- 

  -- PRODUCTIVITY REFINING INTEGRATED MANAGEMENT ENVIRONMENT --   


----------------- express local -----------------

-- new folder
   local folder_creator = require('folder_creator')
   -- Add a Neovim command that calls the create_folder function
   vim.api.nvim_create_user_command('CreateFolder', folder_creator.create_folder, {})
   -- You can also set up a keybinding if you prefer
   vim.api.nvim_set_keymap('n', '<leader>eln', ':CreateFolder<CR>', { noremap = true, silent = true })


----------------- captains log -----------------

--list logs
   local log_filter = require('log_filter')
   vim.api.nvim_create_user_command('GetLogs', log_filter.getLogs, {})
   vim.api.nvim_set_keymap('n', '<leader>cll', ':GetLogs<CR>', { noremap = true, silent = true })

--create logs
   local log_creator = require('log_creator')
   vim.api.nvim_create_user_command('CreateLog', log_creator.create_log, {})
   vim.api.nvim_set_keymap('n', '<leader>cln', ':CreateLog<CR>', { noremap = true, silent = true })

----------------- do list -----------------


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

----------------- vi links -----------------

--save links
local save_links = require('save-links')
vim.api.nvim_create_user_command('SaveLinks', save_links.save_link, {})
vim.api.nvim_set_keymap('n', '<leader>vln', ':SaveLinks<CR>', {noremap= true})

--delete links
local delete_links = require('delete-links')
vim.api.nvim_create_user_command('DeleteLinks', delete_links.list_links, {})
vim.api.nvim_set_keymap('n', '<leader>vld', ':DeleteLinks<CR>', {noremap = true})

--list links
local list_links = require('list-links')
vim.api.nvim_create_user_command('ListLinks', list_links.list_links, {})
vim.api.nvim_set_keymap('n', '<leader>vll', ':ListLinks<CR>', {noremap = true})

local mistral = require('mistral')
vim.api.nvim_create_user_command('Mistral', mistral.execute, {})
vim.api.nvim_set_keymap('n', '<leader>sll', ':Mistral<CR>', {noremap = true})

