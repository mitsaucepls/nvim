-- local function jdtls_config()
--     local jdtls_mason_path = "/home/a200162459/.local/share/nvim/mason/bin/jdtls"
--     local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
--     local jdtls_cache_dir = "/home/a200162459/.cache/jdtls/"
--     local workspace_dir = jdtls_cache_dir .. "/workspace/" .. project_name
--     local config_dir = jdtls_cache_dir .. "/config/"

--     vim.api.nvim_create_autocmd('FileType', {
--         pattern = "java",
--         group = vim.api.nvim_create_augroup('JdtlsAttach', {}),
--         callback = function(_)
--             require("jdtls").start_or_attach({
--                 cmd = {
--                     jdtls_mason_path,
--                     "-configuration", config_dir,
--                     "-data", workspace_dir,
--                     "--jvm-arg=-javaagent:/home/a200162459/.local/share/java/lombok.jar"
--                 },
--                 settings = {
--                     java = {
--                         saveActions = { organizeImports = true },
--                         import = { exclusions = "target/*" },
--                     }
--                 },
--                 root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
--             })
--         end,
--     })
-- end

local CMP_ELLIPSIS_CHAR = '…'
local CMP_ABBR_LENGTH = 25
local CMP_MENU_LENGTH = 40
local function nvim_lsp_config()
    vim.filetype.add({ extension = { templ = "templ" } })

    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "rust_analyzer",
            "tsserver",
            "gopls",
            "jdtls",
            "pyright",
        },
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup {
                    capabilities = vim.tbl_deep_extend(
                        "force",
                        {},
                        vim.lsp.protocol.make_client_capabilities(),
                        require("cmp_nvim_lsp").default_capabilities()
                    )
                }
            end,

            ["lua_ls"] = function()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            workspace = {
                                checkThirdParty = false,
                                -- library = {
                                --     vim.env.VIMRUNTIME
                                --     -- "${3rd}/luv/library"
                                --     -- "${3rd}/busted/library",
                                -- }
                                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                library = vim.api.nvim_get_runtime_file("", true)
                            },
                            diagnostics = {
                                globals = { "vim", "silent", "on_attach" },
                            }
                        }
                    }
                }
            end,
            ["pyright"] = function()
                local lspconfig = require("lspconfig")
                lspconfig.pyright.setup {
                    settings = {
                        pyright = {
                            autoImportCompletion = true,
                        },
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = 'openFilesOnly',
                                useLibraryCodeForTypes = true,
                                typeCheckingMode = 'basic',
                                autoImportCompletion = true,
                            }
                        }
                    },
                }
            end,
            ["htmx"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.htmx.setup {
                    filetypes = { "html" , "templ" },
                }
            end,
            ["html"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.html.setup {
                    filetypes = { "html" , "templ" },
                }
            end,
        }
    })

    local lspconfig = require('lspconfig')
    lspconfig.dartls.setup { }

    vim.diagnostic.config({
        update_in_insert = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

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
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(e)
        local opts = { buffer = e.buf }
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        local buffer = e.buf

        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        -- setup for formatting modifications on save
        -- idk why, but this fails sometimes (occured on python code)
        local augroup_id = vim.api.nvim_create_augroup(
            "FormatModificationsDocumentFormattingGroup",
            { clear = false }
        )
        -- local format_group_name = "FormatModificationsOnSave"
        vim.api.nvim_clear_autocmds({
            group = augroup_id,
            buffer = buffer
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup(
                "FormatModificationsOnSave",
                { clear = false }
            ),
            buffer = buffer,
            callback = function()
                -- check if lsp has the capability to format on save
                if not client.server_capabilities.document_formatting then
                    return
                end

                local result = require("lsp-format-modifications")
                    .format_modifications(client, buffer)
                -- this will fall back to format the entire buffer
                -- if not successful, e.g. if the file is not in vc.
                if not result.success then
                    vim.lsp.buf.format {
                        id = client.id,
                        bufnr = buffer,
                    }
                end
            end,
        })
    end
})

return {
    {
        "williamboman/mason.nvim",
        name = "mason",
        config = true,
    },
    {
        "joechrisellis/lsp-format-modifications.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        name = "mason-lspconfig",
        dependencies = { "mason" },
        config = true,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            'hrsh7th/nvim-cmp',
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "j-hui/fidget.nvim",
        },
        config = nvim_lsp_config
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            }
        }
    },
    -- {
    --     "mfussenegger/nvim-jdtls",
    --     dependencies = { "nvim-lspconfig" },
    --     lazy = true,
    --     ft = "java",
    --     config = jdtls_config,
    -- },
}
