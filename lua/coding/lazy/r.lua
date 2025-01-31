return {
    "R-nvim/R.nvim",
    version = "~0.1.0",
    lazy = false,
    opts = {
        R_args = { "--quiet" },
        external_term = "tmux split-window -h -l 40",
        auto_quit = true,
    },
    keys = {
        {
            "<LocalLeader>gd",
            "<cmd>lua require('r.send').cmd('tryCatch(httpgd::hgd_browse(),error=function(e) {httpgd::hgd();httpgd::hgd_browse()})')<CR>",
            desc = "httpgd",
        },
    }
}
