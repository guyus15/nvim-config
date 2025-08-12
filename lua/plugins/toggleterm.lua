return {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
        open_mapping = '<leader>tt',
        direction = 'horizontal',
        winbar = {
            enabled = true,
            name_formatter = function(term)
                return 'Terminal'
            end
        },
    }
}
