return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "java", "python", "go"},
            sync_install = false,
            ignore_install = { "latex" },
            highlight = { enable = true },
            indent = { enable = true },  
        })
    end
}
