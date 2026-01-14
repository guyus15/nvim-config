return {
    "fedepujol/move.nvim",
    config = function()
        vim.keymap.set("n", "<A-j>", ":move+1<CR>==", { desc = "Move line down" })
        vim.keymap.set("n", "<A-k>", ":move-2<CR>==", { desc = "Move line up" })
        vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
        vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

        vim.keymap.set("n", "<A-h>", "<<", { desc = "Indent left" })
        vim.keymap.set("n", "<A-l>", ">>", { desc = "Indent right" })
        vim.keymap.set("v", "<A-h>", "<gv", { desc = "Indent selection left" })
        vim.keymap.set("v", "<A-l>", ">gv", { desc = "Indent selection right" })

        -- Add Tab and Shift+Tab for indenting
        vim.keymap.set("n", "<Tab>", ">>", { desc = "Indent right" })
        vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Indent left" })
        vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection right" })
        vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Indent selection left" })

        -- Jumplist navigation (forward/backward cursor position)
        vim.keymap.set("n", "<A-,>", "<C-o>", { desc = "Jump backward" })
        vim.keymap.set("n", "<A-.>", "<C-i>", { desc = "Jump forward" })
    end,
}
