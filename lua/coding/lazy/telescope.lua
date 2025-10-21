return {
  {
    'nvim-telescope/telescope.nvim',
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      'nvim-telescope/telescope-fzf-native.nvim',
    },

    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      telescope.setup({
        defaults = {
          path_display = { truncate = 3 },
        },
      })

      require('telescope').load_extension('fzf')

      vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
      vim.keymap.set('n', '<C-p>', builtin.git_files, {})
      vim.keymap.set('n', '<leader>pws', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>pWs', function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>ps', function()
        -- { search = vim.fn.input("Grep > ") }
        builtin.live_grep()
      end)
      vim.keymap.set('n', ',<leader>vh', builtin.help_tags, {})
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
}
