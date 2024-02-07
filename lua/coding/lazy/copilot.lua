return {
    'github/copilot.vim',
    config = function()
        vim.g.copilot_filetypes = {
            ["*"] = false,
            ["javascript"] = true,
            ["typescript"] = true,
            ["lua"] = true,
            ["rust"] = true,
            ["c"] = true,
            ["c#"] = true,
            ["c++"] = true,
            ["go"] = true,
            ["python"] = true,
            ["yaml"] = true,
            ["yml"] = true,
            ["markdown"] = true,
            ["json"] = true,
            ["xml"] = true,
            ["templ"] = true,
            ["dockerfile"] = true,
        }
        -- print(vim.inspect(vim.g.copilot_filetypes))
    end,
}
