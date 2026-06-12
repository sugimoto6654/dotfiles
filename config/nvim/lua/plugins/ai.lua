return {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
    init = function()
        vim.g.copilot_no_tab_map = true
        vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false,
            silent = true,
        })
    end,
}
