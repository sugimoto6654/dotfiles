return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },

        python = { "isort", "black" },

        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        rust = { "rustfmt" },

        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
    config = function(_, opts)
      local conform = require("conform")
      conform.setup(opts)

      vim.keymap.set("n", "<leader>f", function()
        conform.format({
          async = false,
          lsp_fallback = true,
        })
      end, { desc = "Format buffer" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          conform.format({
            bufnr = args.buf,
            async = false,
            lsp_fallback = true,
            timeout_ms = 1000,
          })
        end,
      })
    end,
  },
}
