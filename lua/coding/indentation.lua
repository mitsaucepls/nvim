vim.api.nvim_create_autocmd("FileType", {
    pattern = "r,html,javascript,typescript,json,css,scss,vue,dart,yaml,markdown,typescriptreact,nix,terraform",
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.expandtab = false
    end
})
