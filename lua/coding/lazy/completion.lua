local CMP_ELLIPSIS_CHAR = '…'
local CMP_ABBR_LENGTH = 25
local CMP_MENU_LENGTH = 40

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
        init = function()
            -- max height of completion window
            vim.opt.pumheight = 15
        end,
        config = function()
            local cmp = require("cmp")
            local cmp_select = {behavior = cmp.SelectBehavior.Select}
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                view = { docs = { auto_open = true } },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    -- responsible for abbreviating entries so the window doesn't get too long
                    format = function(_, cmp_item)
                        if cmp_item.abbr ~= nil and string.len(cmp_item.abbr) > CMP_ABBR_LENGTH then
                            cmp_item.abbr = vim.fn.strcharpart(cmp_item.abbr, 0, CMP_ABBR_LENGTH) .. CMP_ELLIPSIS_CHAR
                        end
                        if cmp_item.menu ~= nil and string.len(cmp_item.menu) > CMP_MENU_LENGTH then
                            cmp_item.menu = vim.fn.strcharpart(cmp_item.menu, 0, CMP_MENU_LENGTH) .. CMP_ELLIPSIS_CHAR
                        end
                        return cmp_item
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", group_index = 1 },
                    { name = "luasnip",  group_index = 1 },
                    { name = "buffer",   group_index = 1 },
                    { name = "path",     group_index = 1 },
                }),
            })

            -- cmp-commandline for completing "/" search from buffer
            cmp.setup.cmdline({"/", "?"},{
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                })
            })

            -- cmp-commandline for completing ":" commands
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    {
                        name = "cmdline",
                        option = { ignore_cmds = { "Man", "!" } },
                    },
                })
            })
        end,
    },
    {
        "saadparwaiz1/cmp_luasnip",
        dependencies = { "L3MON4D3/LuaSnip" },
    },
}
