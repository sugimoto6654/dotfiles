return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        lua = { "luacheck" },
        markdown = { "markdownlint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })

      vim.keymap.set("n", "<leader>l", function()
        require("lint").try_lint()
      end, { desc = "Run lint" })
    end,
  },
}
