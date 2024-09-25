-- [[ Vim Global Table ]]
-- set <space> as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- indicate nerd font use
vim.g.have_nerd_font = true

--[[
╭────────────────────────────────────────────────────────────────────────────╮
│  Str  │  Help page   │  Affected modes                           │  VimL   │
│────────────────────────────────────────────────────────────────────────────│
│  ''   │  mapmode-nvo │  Normal, Visual, Select, Operator-pending │  :map   │
│  'n'  │  mapmode-n   │  Normal                                   │  :nmap  │
│  'v'  │  mapmode-v   │  Visual and Select                        │  :vmap  │
│  's'  │  mapmode-s   │  Select                                   │  :smap  │
│  'x'  │  mapmode-x   │  Visual                                   │  :xmap  │
│  'o'  │  mapmode-o   │  Operator-pending                         │  :omap  │
│  '!'  │  mapmode-ic  │  Insert and Command-line                  │  :map!  │
│  'i'  │  mapmode-i   │  Insert                                   │  :imap  │
│  'l'  │  mapmode-l   │  Insert, Command-line, Lang-Arg           │  :lmap  │
│  'c'  │  mapmode-c   │  Command-line                             │  :cmap  │
│  't'  │  mapmode-t   │  Terminal                                 │  :tmap  │
╰────────────────────────────────────────────────────────────────────────────╯
--]]

local map = function(tbl)
  vim.keymap.set(tbl[1], tbl[2], tbl[3], tbl[4])
end

local imap = function(tbl)
  vim.keymap.set('i', tbl[1], tbl[2], tbl[3])
end

local nmap = function(tbl)
  vim.keymap.set('n', tbl[1], tbl[2], tbl[3])
end

local vmap = function(tbl)
  vim.keymap.set('v', tbl[1], tbl[2], tbl[3])
end

local tmap = function(tbl)
  vim.keymap.set('t', tbl[1], tbl[2], tbl[3])
end

local xmap = function(tbl)
  vim.keymap.set('x', tbl[1], tbl[2], tbl[3])
end

---@diagnostic disable-next-line: unused-local, unused-function
local cmap = function(tbl)
  vim.keymap.set('c', tbl[1], tbl[2], tbl[3])
end

-- [[ Basic Keymaps ]]
-- turn off Ex mode
nmap({ 'Q', '<nop>', { desc = 'Disable Ex mode mapping to Q', noremap = true } })

-- remap <Ctrl+c> -> <Esc>
-- ref: paste in visual block mode (C-v) works iff we exit mode w/ <Esc>
imap({ '<C-c>', '<Esc>', { desc = 'Map Ctrl+C to Escape in insert mode', noremap = true } })

-- copy current file
nmap({ '<Leader>sa', ":saveas <C-R>=expand('%')<CR><Left><Left><Left>", { desc = '[S]ave [A]s current file' } })

-- keep search results in the middle of the screen
nmap({ 'n', 'nzzzv', { desc = 'Jump to next search result, center screen, and reselect', noremap = true } })
nmap({ 'N', 'Nzzzv', { desc = 'Jump to previous search result, center screen, and reselect', noremap = true } })

-- clear search highlights: <Ctrl+c>
function ClearSearchAndUpdateDiff()
  vim.cmd('nohlsearch') -- clear search highlighting
  if vim.fn.has('diff') == 1 then
    vim.cmd('diffupdate') -- update diff display
  end
  vim.cmd('redraw!') -- redraw screen
end

nmap({ '<C-c>', ClearSearchAndUpdateDiff, { desc = 'Clear highlighted search results', noremap = true } })

-- stay in visual mode after indent ops
vmap({ '>', '>gv', { desc = 'Move back to visual mode after right indent', noremap = true } })
vmap({ '<', '<gv', { desc = 'Move back to visual mode after left indent', noremap = true } })

-- [[ Register Keymaps ]]
-- alt paste: map delete during paste to void register; preserve yanked text
xmap({ '<Leader>p', [["_dP]], { desc = 'Paste in visual mode without overwriting the yank register', noremap = true } })

-- alt yank: map to + register (sys clipboard)
map({ { 'n', 'v' }, '<Leader>y', [["+y]], { desc = 'Yank to system clipboard', noremap = true } })
nmap({ '<Leader>Y', [["+Y]], { desc = 'Yank entire line to system clipboard', noremap = true } })

-- alt delete: map to void register in normal and visual modes; preserve yank register
map({ { 'n', 'v' }, '<Leader>d', [["_d]], { desc = 'Delete without affecting the yank register', noremap = true } })

-- delete single character: map to void register; preserve yank register
nmap({ 'x', '"_x', { desc = 'Delete character into null register', noremap = true } })

-- [[ Movement Keymaps ]]
-- <Ctrl+d>, <Ctrl+u> scrolls half-page down, up w/ centered cursor
nmap({ '<C-d>', '<C-d>zz', { desc = 'Scroll half-page down and center cursor', noremap = true } })
nmap({ '<C-u>', '<C-u>zz', { desc = 'Scroll half-page up and center cursor', noremap = true } })

-- quicker window movement (drop the <Ctrl+w>)
nmap({ '<C-j>', '<C-w>j', { desc = 'Move cursor to the lower window', noremap = true } })
nmap({ '<C-k>', '<C-w>k', { desc = 'Move cursor to the upper window', noremap = true } })
nmap({ '<C-h>', '<C-w>h', { desc = 'Move cursor to the left window', noremap = true } })
nmap({ '<C-l>', '<C-w>l', { desc = 'Move cursor to the right window', noremap = true } })

-- tab management
nmap({ '<Leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab', noremap = true } })
nmap({ '<Leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab', noremap = true } })
nmap({ '<Leader>tn', '<cmd>tabn<CR>', { desc = 'Go to next tab', noremap = true } })
nmap({ '<Leader>tp', '<cmd>tabp<CR>', { desc = 'Go to previous tab', noremap = true } })
nmap({ '<Leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab', noremap = true } })

-- quickfix & location list traversal: <F7> and <F9> are usually media keys
-- read about diff & usage: https://stackoverflow.com/questions/20933836/what-is-the-difference-between-location-list-and-quickfix-list-in-vim
nmap({
  '<F9>',
  '<cmd>cnext<CR>zz',
  { desc = 'Go to next item in quickfix list and center on screen', noremap = true, silent = true },
})
nmap({
  '<F7>',
  '<cmd>cprev<CR>zz',
  { desc = 'Go to previous item in quickfix list and center on screen', noremap = true, silent = true },
})
nmap({
  '<Leader>F9',
  '<cmd>lnext<CR>zz',
  { desc = 'Go to next item in location list and center on screen', noremap = true, silent = true },
})
nmap({
  '<Leader>F7',
  '<cmd>lprev<CR>zz',
  { desc = 'Go to previous item in location list and center on screen', noremap = true, silent = true },
})

-- disable arrow keys in normal mode
nmap({ '<left>', '<cmd>echo "Use h to move!!"<CR>' })
nmap({ '<right>', '<cmd>echo "Use l to move!!"<CR>' })
nmap({ '<up>', '<cmd>echo "Use k to move!!"<CR>' })
nmap({ '<down>', '<cmd>echo "Use j to move!!"<CR>' })

-- [[ Misc Keymaps ]]
-- keep cursor at current position when appending lines
nmap({ 'J', 'mzJ`z', { desc = 'Join lines without changing cursor position', noremap = true } })

-- increment/decrement numbers
nmap({ '<Leader>+', '<C-a>', { desc = 'Increment number', noremap = true } })
nmap({ '<Leader>-', '<C-x>', { desc = 'Decrement number', noremap = true } })

-- substitute current word across files
nmap({
  '<Leader>S',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'Substitute the current word globally with prompt for replacement', noremap = true },
})

-- close buffer w/o closing the window
nmap({
  '<Leader>bd',
  '<cmd>bp|bd #<CR>',
  { desc = 'Close buffer without closing the window', noremap = true, silent = true },
})

-- make current file executable
nmap({
  '<Leader>x',
  '<cmd>!chmod +x %<CR>',
  { desc = 'Add executable permissions to current file', noremap = true, silent = true },
})

-- press leader twice to source current file
nmap({
  '<Leader><Leader>',
  function()
    vim.cmd('so %')
  end,
  { desc = 'Source the current file' },
})

-- toggle relative numbering
nmap({ '<C-n>', ':set rnu!<CR>', { desc = 'Toggle relative numbering', noremap = true, silent = true } })

local function show_documentation()
  local filetype = vim.bo.filetype
  local cword = vim.fn.expand('<cword>') -- get word under cursor once

  if vim.tbl_contains({ 'vim', 'help' }, filetype) then
    vim.cmd('h ' .. cword)
  elseif vim.tbl_contains({ 'man' }, filetype) then
    vim.cmd('Man ' .. cword)
  elseif filetype == 'toml' and vim.fn.expand('%:t') == 'Cargo.toml' then
    if require('crates').popup_available() then
      require('crates').show_popup()
    else
      vim.notify('Crates popup not available', vim.log.levels.INFO)
    end
  elseif vim.lsp.buf_is_attached(0, 1) then
    vim.lsp.buf.hover()
  else
    vim.notify('No hover information available', vim.log.levels.INFO)
  end
end

nmap({ 'K', show_documentation, { desc = 'Show Context-Aware Documentation', noremap = true, silent = true } })

-- HACK: format js files using biome in a floating terminal
-- TODO: remove this after neovim v0.10 is released. Dynamic attach will allow lsp formatting w/ biome
function biome_format_in_floating_terminal()
  -- calculate floating window size
  local width = math.floor(vim.o.columns * 0.65)
  local height = math.floor(vim.o.lines * 0.5)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- create a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    border = 'rounded',
  })

  -- start terminal in the floating window
  vim.fn.termopen('~/.local/share/nvim/mason/bin/biome check --apply .')
end

nmap({
  '<Leader>tb',
  '<cmd>lua biome_format_in_floating_terminal()<CR>',
  { desc = '[T]erminal [b]iome format', noremap = true, silent = true },
})
tmap({ '<C-w>q', '<C-\\><C-n>:q!<CR>', { desc = 'Terminal [C-w]indow [q]uit', noremap = true, silent = true } })

-- [[ Diagnostic Keymaps ]]
-- nmap { '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message', noremap = true } }
-- nmap { ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message', noremap = true } }
-- nmap { '<Leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages', noremap = true } }
-- nmap { '<Leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list', noremap = true } }

-- IMP: disable netrw. Ctrl+e is set in nvim-tree for encapsulation
-- -- ensure Netrw changes the current working directory to the directory of the file being edited
-- -- this makes move cmds more intuitive and [S,L,V]Ex opens current file dir
-- -- Gotcha: telescope builtin searches get restricted to current file's dir :/
-- -- Update: replaced with custom user function that tracks netrw buffer status
-- -- IMP: ensure command name does not start with letters similar to existing command.
-- -- For instance, if this were named `LexFileDir`, `:Lex` would fail with "ambiguous
-- -- use of user-defined command"
-- vim.api.nvim_create_user_command('PanelFileDir', function()
--   -- check if a Netrw window is open by looking for buffers with the 'netrw' filetype
--   local is_netrw_open = false
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
--     if ft == 'netrw' then
--       is_netrw_open = true
--       -- if found, close the window containing the Netrw buffer
--       vim.api.nvim_win_close(win, false)
--       break
--     end
--   end
--
--   -- if no Netrw window was found, open Netrw in the directory of the current file
--   if not is_netrw_open then
--     local current_file_dir = vim.fn.expand('%:p:h')
--     vim.cmd('Lexplore ' .. current_file_dir)
--   end
-- end, {desc = "Toggle Netrw in the directory of the current file"})
--
-- -- netrw file explorer as a toggleable vertical left split
-- nmap { '<C-e>', '<cmd>PanelFileDir<CR>', { desc = 'Explore(toggle) file dir', noremap = true, silent = true } }
