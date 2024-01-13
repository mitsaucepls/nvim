print("hello from init")
return {
    
    'folke/tokyonight.nvim',
    
    {
        'rose-pine/neovim', 
        name = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    {
        'nvim-lua/plenary.nvim',
        name "plenary"
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            "plenary"
        }
    },
    {
        'folke/trouble.nvim',
        config = function()
            require('trouble').setup {
                icons = false,
            }
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
    },
    {
        'ThePrimeagen/harpoon',
        branch = "harpoon2",
    },
    
    'ThePrimeagen/vim-be-good',
    'ThePrimeagen/git-worktree.nvim',
    'tpope/vim-surround',
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "tpope/vim-fugitive",
    'nvim-lua/popup.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
	"mbbill/undotree",
    'folke/zen-mode.nvim',
    'github/copilot.vim',
    'eandrju/cellular-automaton.nvim',
    'laytan/cloak.nvim',

}
