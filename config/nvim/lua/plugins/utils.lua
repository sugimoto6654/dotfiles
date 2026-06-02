-- lua/plugins/neo-tree.lua
return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            view_options = {
                show_hidden = true,
                natural_order = true,
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                }
            },
            win_options = {
                signcolumn = "yes:2",
                statuscolumn = "",
            },
        },
        -- Optional dependencies
        -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,

        vim.keymap.set("n", "<leader>e", function()
            require("oil").open()
        end, { desc = "Open Oil floating window" }),

        vim.keymap.set("n", "<leader>d", function()
            local prev_buf = vim.api.nvim_get_current_buf()
            local modified = vim.bo[prev_buf].modified

            require("oil").open()

            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(prev_buf) and not modified then
                    vim.cmd("bdelete " .. prev_buf)
                end
            end)
        end, { desc = "Oil current buffer's directory" }),
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
