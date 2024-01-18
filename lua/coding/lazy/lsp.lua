local function jdtls_config()
    local jdtls_mason_path = "/home/a200162459/.local/share/nvim/mason/bin/jdtls"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local jdtls_cache_dir = "/home/a200162459/.cache/jdtls/"
    local workspace_dir = jdtls_cache_dir .. "/workspace/" .. project_name
    local config_dir = jdtls_cache_dir .. "/config/"

    vim.api.nvim_create_autocmd('FileType', {
        pattern = "java",
        group = vim.api.nvim_create_augroup('JdtlsAttach', {}),
        callback = function(_)
            require("jdtls").start_or_attach({
                cmd = {
                    jdtls_mason_path,
                    "-configuration", config_dir,
                    "-data", workspace_dir,
                    "--jvm-arg=-javaagent:/home/a200162459/.local/share/java/lombok.jar"
                },
                settings = {
                    java = {
                        saveActions = { organizeImports = true },
                        import = { exclusions = "target/*" },
                    }
                },
                -- root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
            })
        end,
    })
end

local function nvim_lsp_config()
    local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
    )

    -- require("fidget").setup({})
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "rust_analyzer",
            "tsserver",
            "gopls",
            "yamlls",
        },
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup {
                    capabilities = capabilities
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
                                globals = { "vim", "silent" }
                            }
                        }
                    }
                }
            end,
        }
    })

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

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        -- setup for formatting modifications on save
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
        "williamboman/mason-lspconfig.nvim",
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
            "williamboman/mason-lspconfig.nvim",
            -- "j-hui/fidget.nvim",
        },
        config = nvim_lsp_config
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "nvim-lspconfig" },
        lazy = true,
        ft = "java",
        config = jdtls_config,
    },
}
