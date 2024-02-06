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

   local log_creator = require('log_creator')
   -- Add a Neovim command that calls the create_log function
   vim.api.nvim_create_user_command('CreateLog', log_creator.create_log, {})
   -- You can also set up a keybinding if you prefer
   vim.api.nvim_set_keymap('n', '<leader>ll', ':CreateLog<CR>', { noremap = true, silent = true })

   local folder_creator = require('folder_creator')
   -- Add a Neovim command that calls the create_folder function
   vim.api.nvim_create_user_command('CreateFolder', folder_creator.create_folder, {})
   -- You can also set up a keybinding if you prefer
   vim.api.nvim_set_keymap('n', '<leader>lc', ':CreateFolder<CR>', { noremap = true, silent = true })

   local todo_creator = require('todo_creator')
vim.api.nvim_create_user_command('ManageTodos', todo_creator.handle_workflow, {})
vim.api.nvim_set_keymap('n', '<leader>td', ':ManageTodos<CR>', {noremap= true})

