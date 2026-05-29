local keymap = vim.keymap
vim.g.mapleader = ' '

keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><C-l>', { silent = true })
vim.cmd([[nnoremap <silent><Leader><Leader> :let @/ = '\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>]])
vim.cmd([[nnoremap # "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///gc<Left><Left><Left>]])
keymap.set('n', '<Leader>s', [[':vimgrep ' . expand('<cword>') . ' % | cw <CR>']], { silent = true, expr = true })
keymap.set('n', '<Leader>ss', [[':vimgrep ' . expand('<cword>') . ' */** | cw <CR>']], { silent = true, expr = true })

keymap.set('n', '<C-h>', '<C-w>h')
keymap.set('n', '<C-j>', '<C-w>j')
keymap.set('n', '<C-k>', '<C-w>k')
keymap.set('n', '<C-l>', '<C-w>l')

keymap.set('n', 'U', '<C-r>')
keymap.set('n', '<C-Y>', '<C-e>')

keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')

keymap.set('n', '<Tab>', ':bnext<CR>')
keymap.set('n', '<S-Tab>', ':bprev<CR>')
-- keymap.set('n', '<leader>d', ':bd<CR>')

keymap.set('n', 'x', '"_x')
keymap.set('n', 'c', '"_c')
keymap.set('n', 'C', '"_C')

keymap.set('n', '<S-Up>', '"zdd<Up>"zP')
keymap.set('n', '<S-Down>', '"zdd"zp')
keymap.set('v', '<S-Up>', '"zx<Up>"zP`[V`]')
keymap.set('v', '<S-Down>', '"zx"zP`[V`]')

keymap.set('v', 'v', '<C-v>')
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

keymap.set('n', '<Leader>a', 'ggVG')
keymap.set('n', '<Leader><BS>', 'mzO<ESC>`z')
keymap.set('n', '<Leader><CR>', 'mzo<ESC>`z')

keymap.set('n', '<Leader>n', ':tabnew<CR>')
keymap.set('n', '<Leader>x', ':tabclose<CR>')
keymap.set('n', '<Leader>l', ':tabnext<CR>', { silent = true })
keymap.set('n', '<Leader>h', ':tabprevious<CR>', { silent = true })

-- keymap.set('t', '<Esc>', '<C-\\><C-n>')
