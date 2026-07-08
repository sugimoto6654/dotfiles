return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        keys = {
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute({
                        action = "focus",
                        source = "filesystem",
                        position = "left",
                        reveal = true,
                    })
                end,
                desc = "Focus file tree",
            },
            {
                "<leader>E",
                function()
                    require("neo-tree.command").execute({
                        source = "filesystem",
                        position = "left",
                        reveal = true,
                    })
                end,
                desc = "Reveal current file in tree",
            },
            {
                "<leader>b",
                function()
                    require("neo-tree.command").execute({
                        toggle = true,
                        source = "buffers",
                        position = "left",
                    })
                end,
                desc = "Toggle buffer tree",
            },
            {
                "<leader>g",
                function()
                    require("neo-tree.command").execute({
                        toggle = true,
                        source = "git_status",
                        position = "left",
                    })
                end,
                desc = "Toggle git status tree",
            },
        },
        opts = {
            close_if_last_window = true,
            enable_git_status = true,
            enable_diagnostics = true,
            source_selector = {
                winbar = true,
                statusline = false,
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        added = "A",
                        modified = "M",
                        deleted = "D",
                        renamed = "R",
                        untracked = "?",
                        ignored = "!",
                        unstaged = "U",
                        staged = "S",
                        conflict = "C",
                    },
                },
            },
            window = {
                position = "left",
                width = 36,
                mappings = {
                    ["<space>"] = { "toggle_node", nowait = false },
                    ["<tab>"] = "next_source",
                    ["<cr>"] = "open",
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["S"] = "open_split",
                    ["s"] = "open_vsplit",
                    ["t"] = "open_tabnew",
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["R"] = "refresh",
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["A"] = "add_directory",
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["q"] = "close_window",
                    ["?"] = "show_help",
                    ["<leader>e"] = function()
                        local ok, neo_tree = pcall(require, "neo-tree")
                        local winid = ok and neo_tree.get_prior_window() or -1

                        if winid > 0 then
                            vim.api.nvim_set_current_win(winid)
                        else
                            vim.cmd.wincmd("p")
                        end
                    end,
                },
            },
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true,
                },
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
        },
    },

    {
        'akinsho/toggleterm.nvim',
        version = '*',
        config = function()
            require('toggleterm').setup {
                size = 20,
                open_mapping = [[<C-/>]],
                hide_numbers = true,
                shade_filetypes = {},
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = 'float',
                close_on_exit = true,
                shell = vim.o.shell,
                highlights = {
                    float_border = {
                        guifg = '#fdf6e3',
                        guibg = '#1d2021',
                    },
                },
                float_opts = {
                    border = 'double',
                }
            }
        end,
        vim.keymap.set('t', '<ESC>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' }),
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",  -- 挿入モードに入ったとき読み込み
        dependencies = {
            "hrsh7th/nvim-cmp", -- 補完連携を行う場合
        },
        config = function()
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            npairs.setup({
                check_ts = true,        -- treesitter連携で文脈判断
                ts_config = {
                    lua = { "string" }, -- string内では補完を無効化
                    javascript = { "template_string" },
                },
                disable_filetype = { "TelescopePrompt", "vim" },
                fast_wrap = {
                    map = "<M-e>", -- Alt+e で括弧を素早く閉じる
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "PmenuSel",
                    highlight_grey = "LineNr",
                },
            })

            -- nvim-cmpとの統合設定
            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok then
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end

            -- 必要なら独自ルールを追加（例：スペース入りの括弧）
            npairs.add_rules({
                Rule(" ", " ")
                    :with_pair(function(opts)
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return vim.tbl_contains({ "()", "{}", "[]" }, pair)
                    end),
            })
        end,
    },
}
