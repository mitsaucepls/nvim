vim.api.nvim_create_autocmd("FileType", {
  pattern = "r,html,javascript,typescript,json,css,scss,vue,dart,markdown,typescriptreact,nix,terraform,lua,bib,tex,sh,helm,yaml",
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
vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "markdown" then
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "plaintex,tex",
    callback = function()
        vim.bo.textwidth = 100
    end,
})
