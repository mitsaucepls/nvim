vim.api.nvim_create_autocmd("FileType", {
    pattern = "html,javascript,typescript,json,css,scss,vue,dart,yaml,markdown,typescriptreact,nix",
    command = "setlocal shiftwidth=2 tabstop=2"
})
