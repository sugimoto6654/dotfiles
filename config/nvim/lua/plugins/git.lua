return {
   {
    "FerretDetective/oil-git-signs.nvim",
    ft = "oil",
    opts = {
      -- git 操作時に確認を出す。誤 stage / unstage 防止のため true 推奨
      confirm_git_operations = true,

      -- 小規模な stage / unstage では確認を省略
      -- 慣れていないうちは false のままでもよい
      skip_confirm_for_simple_git_operations = false,

      simple_git_operations = {
        max_stages = 5,
        max_unstages = 5,
      },

      -- ignored まで拾うと repo 全体の走査が重くなりやすいため表示しない
      show_ignored = function()
        return false
      end,

      -- 未追跡ファイルの再帰的な全列挙を避け、oil 表示時の git status を軽くする
      git_shell_cmd = {
        "git",
        "-c",
        "status.relativePaths=false",
        "status",
        "--short",
        "--untracked-files=normal",
      },

      keymaps = {
        {
          "n",
          "[H",
          function()
            require("oil-git-signs").jump_to_status("up", -vim.v.count1)
          end,
          { desc = "Jump to first git status" },
        },
        {
          "n",
          "]H",
          function()
            require("oil-git-signs").jump_to_status("down", -vim.v.count1)
          end,
          { desc = "Jump to last git status" },
        },
        {
          "n",
          "[h",
          function()
            require("oil-git-signs").jump_to_status("up", vim.v.count1)
          end,
          { desc = "Jump to previous git status" },
        },
        {
          "n",
          "]h",
          function()
            require("oil-git-signs").jump_to_status("down", vim.v.count1)
          end,
          { desc = "Jump to next git status" },
        },
        {
          { "n", "v" },
          "<leader>gs",
          function()
            require("oil-git-signs").stage_selected()
          end,
          { desc = "Stage selected oil entries" },
        },
        {
          { "n", "v" },
          "<leader>gu",
          function()
            require("oil-git-signs").unstage_selected()
          end,
          { desc = "Unstage selected oil entries" },
        },
      },
    },
  },
}
