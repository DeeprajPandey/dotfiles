-- [[ Autocommands ]]
-- Highlight when yanking (copying) text; ref: `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Close certain filetypes easily with 'q' and set them as non-listed
-- this is useful for temporary buffers like netrw, help pages, etc.
vim.api.nvim_create_autocmd("FileType", {
  -- list of filetypes this will apply to
  pattern = {
    'netrw',
    'Jaq',
    'qf',
    'git',
    'help',
    'man',
    'lspinfo',
    'oil',
    'spectre_panel',
    'lir',
    'DressingSelect',
    'tsplayground',
  },
  callback = function()
    -- buffer-local mapping to close the buffer with 'q' w/o additional inputs
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':close<CR>', { desc = 'Close window', silent = true, nowait = true })
    -- set the current buffer as non-listed
    vim.bo.buflisted = false
  end,
})

-- Automatically trim trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Disable line numbers in terminal mode
vim.api.nvim_create_autocmd({'TermOpen'}, {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Set spell checking for certain file types
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  pattern = {'*.txt', '*.md'},
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Equalize window dimensions across all tabs when Neovim window is resized
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- open a terminal buffer in a split on startup
-- vim.api.nvim_create_autocmd('VimEnter', {
--   pattern = '*',
--   callback = function()
--     -- only run if there's a single window and buffer open to avoid interference.
--     if vim.fn.winnr('$') == 1 and vim.fn.bufnr('$') == 1 then
--       vim.cmd('split | terminal')
--     end
--   end,
-- })

-- setup custom minimal statusline for markdown files
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = {'markdown', 'text'},
--   callback = function()
--     vim.wo.statusline = '%f - word count: %w'
--   end,
-- })

