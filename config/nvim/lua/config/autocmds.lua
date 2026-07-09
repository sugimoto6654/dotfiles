-- neo-treeにフォーカス中は :q / :quit で他ウィンドウではなくnvim全体を終了する
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.cmd("cnoreabbrev <buffer> q qa")
    vim.cmd("cnoreabbrev <buffer> quit qa")
  end,
})
