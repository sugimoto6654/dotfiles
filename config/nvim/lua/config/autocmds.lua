-- neo-treeにフォーカス中は :q / :quit で他ウィンドウではなくnvim全体を終了する
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.cmd("cnoreabbrev <buffer> q qa")
    vim.cmd("cnoreabbrev <buffer> quit qa")
  end,
})

-- Markdown は画面幅で折り返し、単語の途中で切らない
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function(event)
    local is_markdown = vim.bo[event.buf].filetype == "markdown"
    vim.opt_local.wrap = is_markdown
    vim.opt_local.linebreak = is_markdown
    vim.opt_local.breakindent = is_markdown
  end,
})
