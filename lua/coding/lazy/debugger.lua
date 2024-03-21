return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function(_, opts)
            local dapui = require("dapui")
            local dap = require("dap")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            vim.api.nvim_set_keymap("n", "<leader>@t", "<CMD> lua require('dapui').toggle() <CR>", {noremap=true})
            vim.api.nvim_set_keymap("n", "<leader>@b", "<CMD> DapToggleBreakpoint <CR>", {noremap=true})
            vim.api.nvim_set_keymap("n", "<leader>@c", "<CMD> DapContinue<CR>", {noremap=true})
            vim.api.nvim_set_keymap("n", "<leader>@r", "<CMD> lua require('dapui').open({reset = true})<CR>", {noremap=true})
        end,
    },
    {
        "mfussenegger/nvim-dap",
    },
    {
        "theHamsta/nvim-dap-virtual-text",
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function(_, opts)
            require("dap-go").setup()
        end,
    },
}
