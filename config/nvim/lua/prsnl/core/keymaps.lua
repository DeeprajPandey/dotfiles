-- [[ Vim Global Table ]]
-- set <space> as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ensure Netrw changes the current working directory to the directory of the file being edited
-- this makes move cmds more intuitive and [S,L,V]Ex opens current file dir
-- Gotcha: telescope builtin searches get restricted to current file's dir :/
-- vim.g.netrw_keepdir = 0

-- indicate nerd font use
vim.g.have_nerd_font = true

-- keep config concise
local keymap = vim.keymap


-- [[ Basic Keymaps ]]
-- turn off Ex mode
keymap.set('n', 'Q', '<nop>', { desc = 'Disable Ex mode mapping to Q', noremap = true })

-- remap <Ctrl+c> -> <Esc>
-- ref: paste in visual block mode (C-v) works iff we exit mode w/ <Esc>
keymap.set('i', '<C-c>', '<Esc>', { desc = 'Map Ctrl+C to Escape in insert mode', noremap = true })

-- netrw file explorer as a toggleable vertical left split
keymap.set('n', '<C-e>', '<cmd>Lexplore<CR>', { desc = 'Explore(toggle) file dir', noremap = true, silent = true })

-- keep search results in the middle of the screen
keymap.set('n', 'n', 'nzzzv', { desc = 'Jump to next search result, center screen, and reselect', noremap = true })
keymap.set('n', 'N', 'Nzzzv', { desc = 'Jump to previous search result, center screen, and reselect', noremap = true })

-- clear search highlights: <Ctrl+c>
function ClearSearchAndUpdateDiff()
  vim.cmd('nohlsearch')   -- clear search highlighting
  if vim.fn.has('diff') == 1 then
    vim.cmd('diffupdate') -- update diff display
  end
  vim.cmd('redraw!')  -- redraw screen
end
keymap.set('n', '<C-c>', ClearSearchAndUpdateDiff, { desc = 'Clear highlighted search results', noremap = true })

-- stay in visual mode after indent ops
keymap.set('v', '>', '>gv', { desc = 'Move back to visual mode after right indent', noremap = true })
keymap.set('v', '<', '<gv', { desc = 'Move back to visual mode after left indent', noremap = true })


-- [[ Register Keymaps ]]
-- alt paste: map delete during paste to void register; preserve yanked text
keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste in visual mode without overwriting the yank register', noremap = true })

-- alt yank: map to + register (sys clipboard)
keymap.set({'n', 'v'}, '<leader>y', [["+y]], { desc = 'Yank to system clipboard', noremap = true })
keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank entire line to system clipboard', noremap = true })

-- alt delete: map to void register in normal and visual modes; preserve yank register
keymap.set({'n', 'v'}, '<leader>d', [["_d]], { desc = 'Delete without affecting the yank register', noremap = true })

-- delete single character: map to void register; preserve yank register
-- keymap.set('n', 'x', '"_x', { desc = 'Delete character into null register', noremap = true })


-- [[ Movement Keymaps ]]
-- <Ctrl+d>, <Ctrl+u> scrolls half-page down, up w/ centered cursor
keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll half-page down and center cursor', noremap = true })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll half-page up and center cursor', noremap = true })

-- quicker window movement (drop the <Ctrl+w>)
keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move cursor to the lower window', noremap = true })
keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move cursor to the upper window', noremap = true })
keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move cursor to the left window', noremap = true })
keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move cursor to the right window', noremap = true })

-- tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab', noremap = true })
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab', noremap = true })
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab', noremap = true })
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab', noremap = true })
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab', noremap = true })

-- quickfix & location list traversal: <F7> and <F9> are usually media keys
-- read about diff & usage: https://stackoverflow.com/questions/20933836/what-is-the-difference-between-location-list-and-quickfix-list-in-vim
keymap.set('n', '<F9>', '<cmd>cnext<CR>zz', { desc = 'Go to next item in quickfix list and center on screen', noremap = true, silent = true })
keymap.set('n', '<F7>', '<cmd>cprev<CR>zz', { desc = 'Go to previous item in quickfix list and center on screen', noremap = true, silent = true })
keymap.set('n', '<leader>F9', '<cmd>lnext<CR>zz', { desc = 'Go to next item in location list and center on screen', noremap = true, silent = true })
keymap.set('n', '<leader>F7', '<cmd>lprev<CR>zz', { desc = 'Go to previous item in location list and center on screen', noremap = true, silent = true })

-- disable arrow keys in normal mode
keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')


-- [[ Misc Keymaps ]]
-- keep cursor at current position when appending lines
keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines without changing cursor position', noremap = true })

-- increment/decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number', noremap = true })
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number', noremap = true })

-- substitute current word across files
keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Substitute the current word globally with prompt for replacement', noremap = true })

-- close buffer w/o closing the window
keymap.set('n', '<leader>bd', '<cmd>bp|bd #<CR>', { desc = 'Close buffer without closing the window', noremap = true, silent = true })

-- make current file executable
keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { desc = 'Add executable permissions to current file', noremap = true, silent = true })

-- press leader twice to source current file
keymap.set('n', '<leader><leader>', function()
  vim.cmd('so %')
end, {desc = 'Source the current file'})

-- toggle relative numbering
keymap.set('n', '<C-n>', ':set rnu!<CR>', { desc = 'Toggle relative numbering', noremap = true, silent = true })


-- [[ Diagnostic Keymaps ]]
-- keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message', noremap = true })
-- keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message', noremap = true })
-- keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages', noremap = true })
-- keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list', noremap = true })

