vim.api.nvim_create_autocmd("FileType", {
    pattern = "html,javascript,typescript,json,css,scss,vue,dart,yaml",
    command = "setlocal shiftwidth=2 tabstop=2"
})
