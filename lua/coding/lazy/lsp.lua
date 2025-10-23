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
            { path = "luvit-meta/library",      words = { "vim%.uv" } },
            { path = "/usr/share/awesome/lib/", words = { "awesome" } },
          },
        },
      },
      { "Bilal2453/luvit-meta",                        lazy = true },
      {
        "mfussenegger/nvim-jdtls",
        opts = {
          flags = {
            allow_incremental_sync = false,
          },
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-11",
                    path = "/usr/lib/jvm/java-11-openjdk/",
                  },
                  {
                    name = "JavaSE-17",
                    path = "/usr/lib/jvm/java-17-openjdk/",
                  },
                  {
                    name = "JavaSE-21",
                    path = "/usr/lib/jvm/java-21-openjdk/",
                  },
                  {
                    name = "JavaSE-25",
                    path = "/usr/lib/jvm/java-25-openjdk/",
                    default = true,
                  },
                }
              }
            }
          }
        },
        config = function(_, opts)
          local bundles = {
            vim.fn.glob(
              vim.fn.stdpath("data") ..
              "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true
            ),
          }
          local java_test_bundles = vim.split(
            vim.fn.glob(
              vim.fn.stdpath("data") ..
              "/mason/packages/java-test/extension/server/*.jar", true
            ), "\n"
          )
          local excluded = {
            "com.microsoft.java.test.runner-jar-with-dependencies.jar",
            "jacocoagent.jar",
          }
          for _, java_test_jar in ipairs(java_test_bundles) do
            local fname = vim.fn.fnamemodify(java_test_jar, ":t")
            if not vim.tbl_contains(excluded, fname) then
              table.insert(bundles, java_test_jar)
            end
          end

          opts.init_options = {
            bundles = bundles
          }

          vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
          vim.lsp.config("jdtls", opts)
        end,
      },
      {
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false,   -- This plugin is already lazy
      },
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim",                           opts = {} },
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

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      -- local lspconfig = require "lspconfig"

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
        svelte = true,
        templ = true,
        taplo = true,
        intelephense = true,
        -- rust_analyzer = true,
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
        vacuum = { manual_install = true },
        -- mojo = { manual_install = true },

        -- Enabled biome formatting, turn off all the other ones generally
        biome = true,
        jdtls = true,

        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = vim.fn.stdpath("data") ..
                    "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                  }
                },
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        },
        vue_ls = true,
        eslint = true,
        -- angularls = true,
        -- ts_ls = true,
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
              schemas = {
                ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                  ".gitlab-ci.yml",
                  ".gitlab-ci.yaml",
                },
                ["https://raw.githubusercontent.com/oapi-codegen/oapi-codegen/HEAD/configuration-schema.json"] = {
                  "oapi.yml",
                  "oapi.yaml",
                },
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["../path/relative/to/file.yml"] = "/.github/workflows/*",
                ["/path/from/root/of/project"] = "/.github/workflows/*",
                -- Mind the k8s version
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
              }
            },
          },
        },
        helm_ls = {
          yamlls = {
            path = "yaml-language-server",
          }
        },
        ols = {},
        -- racket_langserver = { manual_install = true },
        -- roc_ls = { manual_install = true },

        -- gleam = {
        --   manual_install = true,
        -- },

        clangd = {
          -- cmd = { "clangd", unpack(require("custom.clangd").flags) },
          -- TODO: Could include cmd, but not sure those were all relevant flags.
          --    looks like something i would have added while i was floundering
          init_options = { clangdFileStatus = true },

          filetypes = { "c" },
        },

        tailwindcss = true,
      }

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

        -- lspconfig[name].setup(config)
        -- vim.lsp.config(name, {
        --   settings = {
        --     [name] = config,
        --   },
        -- })
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
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
