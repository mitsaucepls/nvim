return {
    "R-nvim/R.nvim",
    lazy = false,
    opts = {
        R_args = { "--quiet" },
        external_term = "tmux split-window -v -l $(($(tmux display -p '#{window_height}') / 2))",
        auto_quit = true,
    },
    keys = {
        {
            "<LocalLeader>gd",
            "<cmd>lua require('r.send').cmd('tryCatch(httpgd::hgd_browse(),error=function(e) {httpgd::hgd();httpgd::hgd_browse()})')<CR>",
            desc = "httpgd",
        },
        {
            "<LocalLeader>ii",
            function()
                local filename = vim.fn.expand("%:p") -- absolute path of current file
                local r_code = string.format([[
                    lines <- readLines("%s")
                    pkgs <- unique(unlist(regmatches(lines, gregexpr("(?<=library\\(|require\\()[\"']?[a-zA-Z0-9\\.]+[\"']?", lines, perl=TRUE))))
                    pkgs <- gsub("[\"']", "", pkgs)
                    for (pkg in pkgs) {
                        if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
                    }
                    lapply(pkgs, library, character.only = TRUE)
                ]], filename)

                require("r.send").cmd(r_code)
            end,
            desc = "Install R libraries",
        },
    }
}
