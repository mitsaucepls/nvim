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
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "transparent",
                    floats = "transparent",
                },
                -- on_colors = function(colors)
                --     colors.white = "#f2e5bc"
                --     colors.red = "#cc6666"
                --     colors.pink = "#fef601"
                --     colors.green = "#99cc99"
                --     colors.yellow = "#f8fe7a"
                --     colors.blue = "#81a2be"
                --     colors.aqua = "#8ec07c"
                --     colors.cyan = "#8abeb7"
                --     colors.purple = "#8e6fbd"
                --     colors.violet = "#b294bb"
                --     colors.orange = "#de935f"
                --     colors.brown = "#a3685a"
                --     colors.seagreen = "#698b69"
                --     colors.turquoise = "#698b69"
                --     colors.background = "#111111"
                --     colors.gray0 = "#111111"
                -- end,
                -- on_highlights = function(hl, c)
                --     hl.Normal = { fg = c.white }
                --     hl.NormalFloat = { fg = c.white }
                --     hl.NormalNC = { fg = c.white }
                --     hl.NormalSB = { fg = c.white }
                --     hl.FloatBorder = { fg = c.white }
                --     hl.FloatTitle = { fg = c.white }
                --     hl.LspFloatWinNormal = { bg = c.white }
                --     hl.LspFloatWinNormal = { bg = c.white }
                --     hl.NvimTreeNormal = { bg = c.white }
                --     hl["@attribute"] = { fg = c.cyan }
                --     hl["@boolean"] = { fg = c.orange }
                --     hl["@character"] = { fg = c.green }
                --     hl["@character.special"] = { fg = c.red }
                --     hl["@conditional"] = { fg = c.red }
                --     hl["@constant"] = { fg = c.orange }
                --     hl["@constant.builtin"] = { fg = c.orange }
                --     hl["@constant.macro"] = { fg = c.orange }
                --     hl["@constructor"] = { fg = c.yellow }
                --     hl["@define"] = { fg = c.cyan }
                --     hl["@definition"] = { fg = c.cyan }
                --     hl["@definition.constant"] = { fg = c.orange }
                --     hl["@definition.function"] = { fg = c.yellow }
                --     hl["@definition.method"] = { fg = c.blue }
                --     hl["@definition.property"] = { fg = c.blue }
                --     hl["@definition.type"] = { fg = c.yellow }
                --     hl["@definition.variable"] = { fg = c.white }
                --     hl["@exception"] = { fg = c.red }
                --     hl["@field"] = { fg = c.green }
                --     hl["@float"] = { fg = c.orange }
                --     hl["@function"] = { fg = c.yellow }
                --     hl["@function.bracket"] = { fg = c.white }
                --     hl["@function.builtin"] = { fg = c.yellow }
                --     hl["@function.call"] = { fg = c.blue }
                --     hl["@function.call.lua"] = { fg = c.blue }
                --     hl["@function.macro"] = { fg = c.yellow }
                --     hl["@keyword"] = { fg = c.violet }
                --     hl["@keyword.coroutine"] = { fg = c.violet }
                --     hl["@keyword.faded"] = { fg = c.white }
                --     hl["@keyword.flow"] = { fg = c.red }
                --     hl["@keyword.function"] = { fg = c.violet }
                --     hl["@keyword.import"] = { fg = c.violet }
                --     hl["@keyword.operator"] = { fg = c.white }
                --     hl["@keyword.package"] = { fg = c.violet }
                --     hl["@keyword.return"] = { fg = c.red }
                --     hl["@label"] = { fg = c.purple }
                --     hl["@macro"] = { fg = c.cyan }
                --     hl["@method"] = { fg = c.blue }
                --     hl["@namespace"] = { fg = c.orange }
                --     hl["@none"] = { fg = c.white }
                --     hl["@number"] = { fg = c.orange }
                --     hl["@operator"] = { fg = c.white }
                --     hl["@parameter"] = { fg = c.yellow }
                --     hl["@parameter.reference"] = { fg = c.blue }
                --     hl["@preproc"] = { fg = c.cyan }
                --     hl["@property"] = { fg = c.blue }
                --     hl["@punctuation"] = { fg = c.white }
                --     hl["@punctuation.bracket"] = { fg = c.white }
                --     hl["@punctuation.delimiter"] = { fg = c.white }
                --     hl["@punctuation.special"] = { fg = c.white }
                --     hl["@repeat"] = { fg = c.red }
                --     hl["@scope"] = { fg = c.red }
                --     hl["@storageclass"] = { fg = c.violet }
                --     hl["@string"] = { fg = c.green }
                --     hl["@string.escape"] = { fg = c.red }
                --     hl["@string.regex"] = { fg = c.orange }
                --     hl["@symbol"] = { fg = c.cyan }
                --     hl["@tag"] = { fg = c.blue }
                --     hl["@tag.attribute"] = { fg = c.orange }
                --     -- hl["@tag.delimiter"] = { fg = c.gray0 }
                --     hl["@text"] = { fg = c.white }
                --     hl["@text.danger"] = { fg = c.red, bold = true }
                --     hl["@text.diff.add"] = { fg = c.green }
                --     hl["@text.diff.delete"] = { fg = c.red }
                --     hl["@text.emphasis"] = { fg = c.white, italic = true }
                --     hl["@text.environment"] = { fg = c.blue }
                --     hl["@text.environment.name"] = { fg = c.blue }
                --     hl["@text.literal"] = { fg = c.green }
                --     hl["@text.math"] = { fg = c.aqua }
                --     hl["@text.note"] = { fg = c.blue, bold = true }
                --     hl["@text.reference"] = { fg = c.blue }
                --     hl["@text.strike"] = { fg = c.white, strikethrough = true }
                --     hl["@text.strong"] = { fg = c.white, bold = true }
                --     hl["@text.title"] = { fg = c.yellow, bold = true }
                --     hl["@text.todo"] = { fg = c.pink, bold = true }
                --     hl["@text.todo.done"] = { fg = c.green, bold = true }
                --     hl["@text.underline"] = { fg = c.white, underline = true }
                --     hl["@text.uri"] = { fg = c.blue, underline = true }
                --     hl["@text.warning"] = { fg = c.orange, bold = true }
                --     hl["@type"] = { fg = c.yellow }
                --     hl["@type.builtin"] = { fg = c.red }
                --     hl["@type.qualifier"] = { fg = c.violet }
                --     hl["@variable"] = { fg = c.white }
                --     hl["@variable.builtin"] = { fg = c.purple }
                --     hl["@variable.global"] = { fg = c.aqua }
                --     hl["@variable.parameter"] = { fg = c.yellow }
                --     hl.TelescopeBorder = { fg = c.cyan }
                --     hl.TelescopeNormal = { fg = c.white }
                --     hl.TelescopePromptBorder = { fg = c.orange }
                --     hl.TelescopePromptTitle = { fg = c.orange }
                --     hl.TelescopeResultsComment = { fg = c.gray0 }
                -- end,
            })
            vim.cmd.colorscheme("tokyonight")
            linenumbercolor()
        end
    },

    -- {
    --     "tjdevries/colorbuddy.nvim",
    --     config = function ()
    --         vim.cmd.colorscheme("gruvbuddy")
    --         require("colorbuddy").colorscheme("gruvbuddy")

    --         local colorbuddy = require("colorbuddy")
    --         local Color = colorbuddy.Color
    --         local Group = colorbuddy.Group
    --         local c = colorbuddy.colors
    --         local g = colorbuddy.groups
    --         local s = colorbuddy.styles

    --         Color.new("brown", "#a3685a")

    --         Group.new("@keyword", c.brown, nil, s.none)
    --         linenumbercolor()
    --     end
    -- },

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
