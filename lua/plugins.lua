return require('packer').startup(function(use)
	-- Configuration is going here

	-- plugin/package management for Neovim
	use 'wbthomason/packer.nvim'	
  use 'whoissethdaniel/mason-tool-installer.nvim'

  -- intergrated terminal
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  require("toggleterm").setup()
end}
	
	-- manage external editor tooling  
	use 'williamboman/mason.nvim'

 	-- DAP for debugging
	use 'mfussenegger/nvim-dap'
  use 'nvim-treesitter/nvim-treesitter'
	use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'mxsdev/nvim-dap-vscode-js'
  use 'liadoz/nvim-dap-repl-highlights'

  -- Telescope used to fuzzy search files
 use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
 }

 -- Use ChatGPT in neovim
use({
  "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup()
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
})

end)
