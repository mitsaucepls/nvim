-- local function nvim_lsp_config()
--     -- require('java').setup()
--     vim.filetype.add({ extension = { templ = "templ" } })

--     require("mason-lspconfig").setup({
--         ensure_installed = {
--             "lua_ls",
--         },
--         handlers = {
--             function(server_name)
--                 require("lspconfig")[server_name].setup {
--                     capabilities = vim.tbl_deep_extend(
--                         "force",
--                         {},
--                         vim.lsp.protocol.make_client_capabilities(),
--                         require("cmp_nvim_lsp").default_capabilities()
--                     )
--                 }
--             end,

--             -- ["jdtls"] = function() end,

--             ["lua_ls"] = function()
--                 local lspconfig = require("lspconfig")
--                 lspconfig.lua_ls.setup {
--                     settings = {
--                         Lua = {
--                             runtime = { version = 'LuaJIT' },
--                             workspace = {
--                                 checkThirdParty = false,
--                             },
--                             diagnostics = {
--                                 globals = { "vim", "silent", "on_attach" },
--                             }
--                         }
--                     }
--                 }
--             end,
--             ["pyright"] = function()
--                 local lspconfig = require("lspconfig")
--                 lspconfig.pyright.setup {
--                     settings = {
--                         pyright = {
--                             autoImportCompletion = true,
--                         },
--                         python = {
--                             analysis = {
--                                 autoSearchPaths = true,
--                                 diagnosticMode = 'openFilesOnly',
--                                 useLibraryCodeForTypes = true,
--                                 typeCheckingMode = 'basic',
--                                 autoImportCompletion = true,
--                             }
--                         }
--                     },
--                 }
--             end,
--             ["htmx"] = function ()
--                 local lspconfig = require("lspconfig")
--                 lspconfig.htmx.setup {
--                     filetypes = { "html" , "templ" },
--                 }
--             end,
--             ["html"] = function ()
--                 local lspconfig = require("lspconfig")
--                 lspconfig.html.setup {
--                     filetypes = { "html" , "templ" },
--                 }
--             end,
--         }
--     })

--     local capabilities = vim.tbl_deep_extend(
--         "force",
--         {},
--         vim.lsp.protocol.make_client_capabilities(),
--         require("cmp_nvim_lsp").default_capabilities()
--     )
--     local lspconfig = require('lspconfig')
--     lspconfig.dartls.setup { capabilities = capabilities }
--     lspconfig.jdtls.setup { capabilities = capabilities }
--     lspconfig.lemminx.setup { capabilities = capabilities }
--     lspconfig.ts_ls.setup {
--         capabilities = capabilities,
--         init_options = {
--             plugins = {
--                 {
--                     name = "@vue/typescript-plugin",
--                     location = "/usr/lib/node_modules/@vue/typescript-plugin",
--                     languages = { "vue" },
--                 },
--             },
--         },
--         filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
--     }
--     lspconfig.vue_language_server.setup { capabilities = capabilities }

--     lspconfig.gdscript.setup { capabilities = capabilities }

--     vim.diagnostic.config({
--         update_in_insert = true,
--         float = {
--             focusable = false,
--             style = "minimal",
--             border = "rounded",
--             source = "always",
--             header = "",
--             prefix = "",
--         },
--     })
-- end

-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--     callback = function(e)
--         local opts = { buffer = e.buf }
--         local client = vim.lsp.get_client_by_id(e.data.client_id)
--         local buffer = e.buf

--         vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
--         vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
--         vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
--         vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
--         -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
--         -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
--         -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
--         -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
--         vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
--         vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
--         -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

--         -- setup for formatting modifications on save
--         -- idk why, but this fails sometimes (occured on python code)
--         local augroup_id = vim.api.nvim_create_augroup(
--             "FormatModificationsDocumentFormattingGroup",
--             { clear = false }
--         )
--         -- local format_group_name = "FormatModificationsOnSave"
--         vim.api.nvim_clear_autocmds({
--             group = augroup_id,
--             buffer = buffer
--         })
--         vim.api.nvim_create_autocmd("BufWritePre", {
--             group = vim.api.nvim_create_augroup(
--                 "FormatModificationsOnSave",
--                 { clear = false }
--             ),
--             buffer = buffer,
--             callback = function()
--                 -- check if lsp has the capability to format on save
--                 if not client.server_capabilities.document_formatting then
--                     return
--                 end

--                 local result = require("lsp-format-modifications")
--                     .format_modifications(client, buffer)
--                 -- this will fall back to format the entire buffer
--                 -- if not successful, e.g. if the file is not in vc.
--                 if not result.success then
--                     vim.lsp.buf.format {
--                         id = client.id,
--                         bufnr = buffer,
--                     }
--                 end
--             end,
--         })
--     end
-- })

-- return {
--     {
--         "mason-org/mason.nvim",
--         name = "mason",
--         config = true,
--     },
--     {
--         "mason-org/mason-lspconfig.nvim",
--         name = "mason-lspconfig",
--         dependencies = { "mason" },
--         config = true,
--     },
--     {
--         "joechrisellis/lsp-format-modifications.nvim",
--         dependencies = {
--             "nvim-lua/plenary.nvim",
--         },
--     },
--     {
--         "neovim/nvim-lspconfig",
--         dependencies = {
--             "mason-org/mason-lspconfig.nvim",
--             "mason-org/mason-registry",
--             "j-hui/fidget.nvim",
--         },
--         config = nvim_lsp_config
--     },
--     {
--         "j-hui/fidget.nvim",
--         opts = {
--             notification = {
--                 window = {
--                     winblend = 0,
--                 },
--             }
--         }
--     },
--     -- {
--     --     "nvim-java/nvim-java"
--     -- },
-- }

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "/usr/share/awesome/lib/", words = { "awesome" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true },
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      { "elixir-tools/elixir-tools.nvim" },

      -- Autoformatting
      -- "stevearc/conform.nvim",

      -- Schema information
      -- "b0o/SchemaStore.nvim",
      -- { dir = "~/plugins/ocaml.nvim" },
    },
    config = function()
      -- Don't do LSP stuff if we're in Obsidian Edit mode
      if vim.g.obsidian then
        return
      end

      local extend = function(name, key, values)
        local mod = require(string.format("lspconfig.configs.%s", name))
        local default = mod.default_config
        local keys = vim.split(key, ".", { plain = true })
        while #keys > 0 do
          local item = table.remove(keys, 1)
          default = default[item]
        end

        if vim.islist(default) then
          for _, value in ipairs(default) do
            table.insert(values, value)
          end
        else
          for item, value in pairs(default) do
            if not vim.tbl_contains(values, item) then
              values[item] = value
            end
          end
        end
        return values
      end

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local servers = {
        bashls = true,
        gopls = {
          -- manual_install = true,
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = true,
        rust_analyzer = true,
        svelte = true,
        templ = true,
        taplo = true,
        intelephense = true,
        r_language_server = true,
        texlab = true,
        -- needs rubocop or sorbet installed idk it works now
        ruby_lsp = true,
        -- sorbet = true,
        pyright = {
          autoImportCompletion = true,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'basic',
                autoImportCompletion = true,
              }
            }
          }
        },
        ruff = { manual_install = true },
        -- mojo = { manual_install = true },

        -- Enabled biome formatting, turn off all the other ones generally
        biome = true,

        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                  }
                },
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        },
        ts_ls = true,
        vue_ls = true,
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              -- schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- cssls = {
        --   server_capabilities = {
        --     documentFormattingProvider = false,
        --   },
        -- },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              -- schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        helm_ls = {
          yamlls = {
            path = "yaml-language-server",
          }
        },
        ols = {},
        racket_langserver = { manual_install = true },
        roc_ls = { manual_install = true },

        -- ocamllsp = {
        --   manual_install = true,
        --   cmd = { "dune", "tools", "exec", "ocamllsp" },
        --   -- cmd = { "dune", "exec", "ocamllsp" },
        --   settings = {
        --     codelens = { enable = true },
        --     inlayHints = { enable = true },
        --     syntaxDocumentation = { enable = true },
        --   },

        --   server_capabilities = { semanticTokensProvider = false },

        --   -- TODO: Check if i still need the filtypes stuff i had before
        -- },

        gleam = {
          manual_install = true,
        },

        -- elixirls = {
        --   cmd = { "/home/tjdevries/.local/share/nvim/mason/bin/elixir-ls" },
        --   root_dir = require("lspconfig.util").root_pattern { "mix.exs" },
        --   -- server_capabilities = {
        --   --   -- completionProvider = true,
        --   --   definitionProvider = true,
        --   --   documentFormattingProvider = false,
        --   -- },
        -- },

        lexical = {
          cmd = { "/home/tjdevries/.local/share/nvim/mason/bin/lexical", "server" },
          root_dir = require("lspconfig.util").root_pattern { "mix.exs" },
          server_capabilities = {
            completionProvider = vim.NIL,
            definitionProvider = true,
          },
        },

        clangd = {
          -- cmd = { "clangd", unpack(require("custom.clangd").flags) },
          -- TODO: Could include cmd, but not sure those were all relevant flags.
          --    looks like something i would have added while i was floundering
          init_options = { clangdFileStatus = true },

          filetypes = { "c" },
        },

        tailwindcss = {
          init_options = {
            userLanguages = {
              elixir = "phoenix-heex",
              eruby = "erb",
              heex = "phoenix-heex",
            },
          },
          filetypes = extend("tailwindcss", "filetypes", { "ocaml.mlx" }),
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  [[class: "([^"]*)]],
                  [[className="([^"]*)]],
                },
              },
              includeLanguages = extend("tailwindcss", "settings.tailwindCSS.includeLanguages", {
                ["ocaml.mlx"] = "html",
              }),
            },
          },
        },
      }

      -- require("ocaml").setup()

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "stylua",
        "lua_ls",
        "delve",
        -- "tailwind-language-server",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
          vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      -- require("custom.autoformat").setup()

      require("lsp_lines").setup()
      vim.diagnostic.config { virtual_text = true, virtual_lines = false }

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })
    end,
  },
  { "qvalentin/helm-ls.nvim", ft = "helm" },
}
