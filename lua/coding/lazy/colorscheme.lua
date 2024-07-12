-- make spaces and tabs visible
vim.opt.list = true
vim.opt.listchars = "tab:→\\x20,space:·"

local function linenumbercolor()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { bold=true })
    vim.api.nvim_set_hl(0, 'LineNr', { bold=true })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { bold=true })
    vim.api.nvim_set_hl(0, 'Comment', { bold=true })
    -- Set the initial highlight for CursorLine
    vim.api.nvim_set_hl(0, "CursorLine", {default=true, blend=50})
    vim.api.nvim_set_hl(0, "NormalFloat", {bg="NONE"})
    vim.api.nvim_set_hl(0, "FloatBorder", {bg="NONE"})
end

return {
    -- {
    --     'folke/tokyonight.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("tokyonight").setup({
    --             style = "storm",
    --             transparent = true,
    --             terminal_colors = true,
    --             styles = {
    --                 comments = { italic = false },
    --                 keywords = { italic = false },
    --                 sidebars = "transparent",
    --                 floats = "transparent",
    --             },
    --         })
    --         vim.cmd.colorscheme("tokyonight")
    --         linenumbercolor()
    --     end
    -- },

    {
        "tjdevries/colorbuddy.nvim",
        config = function ()
            vim.cmd.colorscheme("gruvbuddy")
            linenumbercolor()
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "▏",
            },
            scope = { enabled = false },
        },
    },
}
