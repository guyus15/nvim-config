return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            c = { "clang_format" },
            cpp = { "clang_format" },
            objc = { "clang_format" },
            objcpp = { "clang_format" },
            python = { "ruff_format" },
            lua = { "stylua" },
        },
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 1000,
        },
    },
}
