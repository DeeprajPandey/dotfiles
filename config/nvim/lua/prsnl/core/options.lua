-- Pointers ref. sensible.vim: most config values are added to nvim by default
-- smarttab: true
-- `complete` does not include 'i'; no need to attempt removing it
-- laststatus: 2
-- ruler: true
-- wildmenu: true
-- display: 'lastline'
-- formatoptions: 'tcqj'
-- autoread: true
-- tabpagemax: 50
-- sessionoptions and viewoptions do not have options by default
-- langremap: false

-- keep config concise
local opt = vim.opt
local cmd = vim.cmd

-- line numbers
opt.number = true -- nu
opt.relativenumber = true -- rnu

-- indent options
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true -- expand to spaces
opt.smartindent = true
opt.autoindent = true -- copy indent from current line when starting next
opt.wrap = true

-- reload file from disk on change
-- works with `reload-file-on-update` autocmd
opt.autoread = true

-- vertical lines to mark indent levels; alternative symbols: extends:▶,precedes:◀
opt.listchars =
  { leadmultispace = '▏ ', lead = '·', tab = '» ', trail = '￮', extends = '›', precedes = '‹', nbsp = '‿' }
opt.list = true

-- search settings
opt.ignorecase = true
opt.smartcase = true -- mixed case in query assumes case-sensitive searching
opt.incsearch = true -- incremental search highlight
opt.hlsearch = true -- highlight all search matches

-- show substitutions and other command results in realtime
opt.inccommand = 'split' -- shows off-screen results in preview window

-- appearance
opt.termguicolors = true -- 24-bit rgb colours in TUI
opt.background = 'dark'
opt.cursorline = true -- highlight current cursor line
opt.colorcolumn = '110' -- mark column to limit text to 110 chars
opt.signcolumn = 'number' -- signcolumn in number col by default
opt.showmode = false -- turn off default statusline (using lualine)

-- min. 8 lines of `scrolloff` opt (+3 for treesitter-context & separator)
opt.scrolloff = 11

-- horizontal scrolling and offset columns
opt.sidescroll = 1
opt.sidescrolloff = 3 -- 1 col is extends and precedes symbols

-- open new split panes to the right and bottom
opt.splitright = true
opt.splitbelow = true

-- undo history; give undotree access to full hist file - no native undo handling
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undodir = os.getenv('HOME') .. '/.vim/undo-history'
opt.undofile = true

-- vim behaviour config
opt.updatetime = 200
opt.timeoutlen = 650 -- waittime for mapped sequence to complete
opt.ttimeoutlen = 50 -- wait time for keycode sequence to complete
opt.lazyredraw = true
opt.hidden = true -- allow auto-hiding of edited buffers
opt.isfname:append('@-@')
-- opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- disable audible bell
opt.errorbells = false
opt.visualbell = true

-- turn off automatic lib provider lookup
cmd('let g:loaded_python3_provider = 0')
cmd('let g:loaded_ruby_provider = 0')
cmd('let g:loaded_node_provider = 0')
cmd('let g:loaded_perl_provider = 0')
