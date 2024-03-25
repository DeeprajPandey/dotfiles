-- set <space> as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- indicate nerd font use
vim.g.have_nerd_font = true

-- keep config concise
local keymap = vim.keymap

-- remap <Ctrl+c> -> <Esc>
-- ref: paste in visual block mode (C-v) works iff we exit mode w/ <Esc>
keymap.set('i', '<C-c>', '<Esc>', { desc = 'Map Ctrl+C to Escape in insert mode', noremap = true })

-- clear search highlights: <C-c>
function ClearSearchAndUpdateDiff()
  vim.cmd('nohlsearch')   -- clear search highlighting
  if vim.fn.has('diff') == 1 then
    vim.cmd('diffupdate') -- update diff display
  end
  vim.cmd('redraw!')  -- redraw screen
end
keymap.set('n', '<C-c>', ClearSearchAndUpdateDiff, { desc = 'Clear highlighted search results', noremap = true })

-- increment/decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number', noremap = true })
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number', noremap = true })


-- quickfix & location list traversal: <F7> and <F9> are usually media keys
-- read about diff & usage: https://stackoverflow.com/questions/20933836/what-is-the-difference-between-location-list-and-quickfix-list-in-vim
keymap.set('n', '<F9>', '<cmd>cnext<CR>zz', { desc = 'Go to next item in quickfix list and center on screen', noremap = true, silent = true })
keymap.set('n', '<F7>', '<cmd>cprev<CR>zz', { desc = 'Go to previous item in quickfix list and center on screen', noremap = true, silent = true })
keymap.set('n', '<leader>F9', '<cmd>lnext<CR>zz', { desc = 'Go to next item in location list and center on screen', noremap = true, silent = true })
keymap.set('n', '<leader>F7', '<cmd>lprev<CR>zz', { desc = 'Go to previous item in location list and center on screen', noremap = true, silent = true })

-- quicker window movement (drop the C-w)
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move cursor to the window below', noremap = true })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move cursor to the window above', noremap = true })
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move cursor to the left window', noremap = true })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move cursor to the right window', noremap = true })

-- tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab', noremap = true })
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab', noremap = true })
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab', noremap = true })
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab', noremap = true })
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab', noremap = true })

-- delete single character without copying into register
-- keymap.set('n', 'x', '"_x', { desc = 'Delete character into null register', noremap = true })

-- Diagnostic keymaps
-- keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message', noremap = true })
-- keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message', noremap = true })
-- keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages', noremap = true })
-- keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list', noremap = true })

