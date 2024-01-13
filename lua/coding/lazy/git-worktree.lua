return {

    "ThePrimeagen/git-worktree.nvim",
    config = function()
        vim.keymap.set("n", "<leader>gws", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
        vim.keymap.set("n", "<leader>gwc", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)

    end
}
