-- set leader key to ,
vim.g.mapleader = ','

-- chatgpt keymaps
-- ask 
vim.keymap.set('n', '<leader>cg', '<cmd>ChatGPT<cr>')
-- ask as persona
vim.keymap.set('n', '<leader>cga', '<cmd>ChatGPTActAs<cr>')
-- run
vim.keymap.set('n', '<leader>cgr', '<cmd>ChatGPTRun<cr>')
--edit with instructions
vim.keymap.set('n', '<leader>cgi', function()require('chatgpt').edit_with_instructions()end)

-- Set keymaps to control the debugger
vim.keymap.set('n', '<leader>ui', require 'dapui'.toggle)
vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', function()
  require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
