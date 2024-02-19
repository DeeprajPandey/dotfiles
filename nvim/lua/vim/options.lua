-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- indent options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.smartindent = true
vim.opt.wrap = false

-- no vim undo actions; give undotree access to full hist file
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undo-history"
vim.opt.undofile = true

-- incremental search highlight but not the search results
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- min. 8 lines of scroll offset (+3 for treesitter-context & separator)
vim.opt.scrolloff = 11
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "110"

-- turn off automatic lib provider lookup
vim.cmd "let g:loaded_python3_provider = 0"
vim.cmd "let g:loaded_ruby_provider = 0"
vim.cmd "let g:loaded_node_provider = 0"
vim.cmd "let g:loaded_perl_provider = 0"

