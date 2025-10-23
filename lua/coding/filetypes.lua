vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

vim.filetype.add {
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
  },
}
