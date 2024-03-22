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

-- no vim undo actions; give undotree access to full hist file
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undo-history"
opt.undofile = true

-- incremental search highlight
opt.hlsearch =  true
opt.incsearch = true

-- min. 8 lines of scroll offopt (+3 for treesitter-context & separator)
opt.scrolloff = 11
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

-- vertical lines to mark indent levels
-- extends:▶,precedes:◀
opt.listchars = "leadmultispace:▏   ,lead:￮,tab:» ,trail:·,extends:›,precedes:‹,nbsp:‿"
opt.list = true
opt.lbr = true

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

