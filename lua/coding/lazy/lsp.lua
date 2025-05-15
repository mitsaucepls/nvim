local function nvim_lsp_config()
    -- require('java').setup()
    vim.filetype.add({ extension = { templ = "templ" } })

    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
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

            -- ["jdtls"] = function() end,

            ["lua_ls"] = function()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            workspace = {
                                checkThirdParty = false,
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

    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
    )
    local lspconfig = require('lspconfig')
    lspconfig.dartls.setup { capabilities = capabilities }
    lspconfig.jdtls.setup { capabilities = capabilities }
    lspconfig.lemminx.setup { capabilities = capabilities }
    lspconfig.ts_ls.setup {
        capabilities = capabilities,
        init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = "/usr/lib/node_modules/@vue/typescript-plugin",
                    languages = { "vue" },
                },
            },
        },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }
    lspconfig.vue_language_server.setup { capabilities = capabilities }

    lspconfig.gdscript.setup { capabilities = capabilities }

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
        "mason-org/mason.nvim",
        name = "mason",
        config = true,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        name = "mason-lspconfig",
        dependencies = { "mason" },
        config = true,
    },
    {
        "joechrisellis/lsp-format-modifications.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "mason-org/mason-registry",
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
    --     "nvim-java/nvim-java"
    -- },
}
