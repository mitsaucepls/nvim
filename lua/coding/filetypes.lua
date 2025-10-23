vim.filetype.add({
    expension = {
        templ = 'templ',
    }
})

vim.filetype.add {
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
  },
}

vim.filetype.add {
  pattern = {
    ['.gitlab-ci.ya?ml'] = 'yaml.gitlab-ci',
  },
}
