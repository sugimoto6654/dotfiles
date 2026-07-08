local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.showcmd = true
opt.wildmenu = true
opt.visualbell = true
opt.swapfile = false
opt.undofile = true
opt.backup = false

opt.expandtab = true
opt.smarttab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true

vim.g.python_indent = {
  open_paren = "shiftwidth()",
  closed_paren_align_last_line = false,
}

opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.foldenable = false

opt.clipboard = 'unnamed'
opt.foldmethod = 'indent'
opt.whichwrap = 'h,l'
opt.backspace = '2'
opt.backspace = {'indent', 'eol', 'start'}
opt.list = true
opt.listchars = {tab = '>-', eol = '↲'}

-- make parmament undo history
local home = os.getenv("HOME")
if not vim.fn.isdirectory(vim.fn.expand(home .. "/.config/nvim/undodir")) then
  vim.fn.mkdir(vim.fn.expand(home .. "/.config/nvim/undodir"), "p")
end
opt.undodir = home .. "/.config/nvim/undodir"

vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

vim.diagnostic.config({
    float = {
        border = "double",
    },
})
