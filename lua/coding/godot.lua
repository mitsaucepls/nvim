local projectfile = vim.fn.getcwd() .. '/project.godot'
if vim.uv.fs_stat(projectfile) then
    vim.fn.serverstart('/tmp/godot.pipe')
end
