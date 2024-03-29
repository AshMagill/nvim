  return require('packer').startup(function(use)
	-- Configuration is going here

	-- plugin/package management for Neovim
	use 'wbthomason/packer.nvim'	
  use 'whoissethdaniel/mason-tool-installer.nvim'
	
	-- manage external editor tooling  
	use 'williamboman/mason.nvim'

  use 'nvim-lua/plenary.nvim'

 	-- DAP for debugging
	use 'mfussenegger/nvim-dap'
  use 'nvim-treesitter/nvim-treesitter'
	use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'mxsdev/nvim-dap-vscode-js'
  use 'liadoz/nvim-dap-repl-highlights'

  -- Intergrated Terminal
use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  require("toggleterm").setup()
end}

  -- Telescope used to fuzzy search files
 use {
    'nvim-telescope/telescope.nvim', tag = '1.0.0', 
    requires = { {'nvim-lua/plenary.nvim'} }
}

  --Use ChatGPT in neovim
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

-- use local ai in vim
use({
    "David-Kunz/gen.nvim"
})

--use'm4xshen/hardtime.nvim'

use {
	'arnarg/todotxt.nvim',
	requires = {'MunifTanjim/nui.nvim'},
}
end)
