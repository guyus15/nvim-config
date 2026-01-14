return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "cpp",
                "lua",
                "vim",
                "vimdoc",
                "javascript",
                "typescript",
                "python",
                "rust",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
            },
        })
    end,
    lazy = false,
    build = ":TSUpdate",
}
