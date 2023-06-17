return require('packer').startup(function(use)
	-- Configuration is going here
	
	-- plugin/package management for Neovim
	use 'wbthomason/packer.nvim'	

	-- manage external editor tooling  
	use 'williamboman/mason.nvim'

	-- Plugins for code completion 

 	-- DAP for debugging
	use 'mfussenegger/nvim-dap'
	use {
		'rcarriga/nvim-dap-ui',
		requires = {
			"mfussenegger/nvim-dap"
		}
	}

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

  -- allows neovim to connect to vscode-js-debug with dap
 use 'mxsdev/nvim-dap-vscode-js'

  -- vscode debug server
 use {
  "microsoft/vscode-js-debug",
  opt = true,
  run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out" 
}
 -- nvim debugging for reactnative
use 'sultanahamer/nvim-dap-reactnative'

end)

