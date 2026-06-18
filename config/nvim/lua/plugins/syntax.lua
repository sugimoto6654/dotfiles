-- lua/plugins/treesitter.lua など
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "css",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                    "typescript",
                    "yaml",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { "python" },
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
            })
        end,
        dependencies = {
            -- "p00f/nvim-ts-rainbow", -- for rainbow parentheses
            "nvim-treesitter/nvim-treesitter-context", -- for context-aware highlighting
            "nvim-treesitter/playground",              -- for treesitter playground
        },
    },

    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                delay = 100,
                under_cursor = false,
                large_file_cutoff = 10000,
                min_count_to_highlight = 1,
            })
        end,
    },
}
