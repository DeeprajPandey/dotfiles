-- Pointers ref. sensible.vim: most config values are added to nvim by default
-- ttimeoutlen is set to 50ms
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
local opt = vim.opt
local cmd = vim.cmd

-- line numbers
opt.nu = true
opt.rnu = true

-- indent options
opt.autoindent = false
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true
opt.wrap = false

-- vertical lines to mark indent levels
-- extends:▶,precedes:◀
opt.listchars = "leadmultispace:▏   ,lead:￮,tab:» ,trail:·,extends:›,precedes:‹,nbsp:‿"
opt.list = true
opt.lbr = true

-- horizontal scrolling and offset columns
opt.sidescroll = 1
opt.sidescrolloff = 3   -- 1 col is extends and precedes symbols

-- no vim undo actions; give undotree access to full hist file
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undo-history"
opt.undofile = true

-- incremental search highlight
opt.incsearch = true

-- highlight all search matches
opt.hlsearch =  true

-- min. 8 lines of scroll offopt (+3 for treesitter-context & separator)
opt.scrolloff = 11
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

-- mark column to limit text to 110 chars
opt.colorcolumn = "110"
opt.lazyredraw = true

-- allow auto-hiding of edited buffers
opt.hidden = true

-- smart case-sensitive search
opt.ignorecase = true
opt.smartcase = true

-- mouse mode
opt.mouse = "a"

-- disable audible bell
opt.errorbells = false
opt.visualbell = true

-- open new split panes to the right and bottom
opt.splitbelow = true
opt.splitright = true

-- turn off automatic lib provider lookup
cmd "let g:loaded_python3_provider = 0"
cmd "let g:loaded_ruby_provider = 0"
cmd "let g:loaded_node_provider = 0"
cmd "let g:loaded_perl_provider = 0"

