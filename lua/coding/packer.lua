-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use 'tpope/vim-surround'
    use 'nvim-lua/popup.nvim'
    use "tpope/vim-commentary"
    use "tpope/vim-repeat"
    use 'nvim-telescope/telescope-fzy-native.nvim'

	use ({
		'rose-pine/neovim', 
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}

    use "nvim-lua/plenary.nvim"
	use("nvim-treesitter/playground")
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
	use("mbbill/undotree")
	use("tpope/vim-fugitive")

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},
		}
	}

    use {
        'rcarriga/nvim-dap-ui',
        requires = {'mfussenegger/nvim-dap'}
    }

    use 'theHamsta/nvim-dap-virtual-text'
    use 'leoluz/nvim-dap-go'
    require('dapui').setup()
    require('dap-go').setup()
    require('nvim-dap-virtual-text').setup()
    require('git-worktree').setup()
    require('telescope').load_extension('git_worktree')

    use 'ThePrimeagen/git-worktree.nvim'
end)
