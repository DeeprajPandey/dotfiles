-- [[ Autocommands ]]
local function update_listchars()
  local ts = vim.opt.softtabstop:get()
  local current_listchars = vim.opt.listchars:get()

  local spaces = string.rep(' ', math.max(ts - 1, 0))
  -- print("Tabstop:", ts, "Spaces length:", #spaces)
  current_listchars['leadmultispace'] = '▏' .. spaces

  -- BUG: `»` (U+00BB) followed by 3 spaces is not accepted as a valid value for `tab` in listchars object.
  -- 1,2,4 spaces are okay. Seems to be an issue with how the character width is rendered by nvim.
  -- TODO: try with different terminal font and in clean mode. If not resolved, open Issue on neovim repo.

  vim.opt.listchars = current_listchars
  vim.opt.shiftwidth = ts -- update shiftwidth to softtabstop
end

-- Update listchars whenever tabstop changes
vim.api.nvim_create_autocmd({ 'OptionSet' }, {
  desc = 'Update listchars based on the current value of softtabstop when it changes',
  group = vim.api.nvim_create_augroup('update-listchars', { clear = true }),
  pattern = 'softtabstop',
  callback = update_listchars,
})

-- Update buffer contents when file is updated outside vim
-- Ref: https://stackoverflow.com/questions/2490227/how-does-vims-autoread-work
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  desc = "Automatically check for reloading file when it's changed externally. Fixes autoread behaviour",
  group = vim.api.nvim_create_augroup('reload-file-on-update', { clear = true }),
  pattern = '*', -- apply to all buffers
  command = 'checktime',
})

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
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Close window and set buffer as non-listed on `q` for specific filetypes',
  group = vim.api.nvim_create_augroup('transient-filetypes', { clear = true }),
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
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':close<CR>', {
      desc = 'Close window',
      silent = true,
      nowait = true,
    })
    -- set the current buffer as non-listed
    vim.bo.buflisted = false
  end,
})

-- Remap netrw's <C-l> (NetrwRefresh) with window nav right within netrw buffer
-- netrw autorefreshes on navigating b/w directories and on ever `:(*)explore` call
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  group = vim.api.nvim_create_augroup('NetrwGroup', { clear = true }),
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.keymap.set('n', '<C-l>', '<C-w>l', {
      desc = '(Netrw Overwrite) Move cursor to the right window. Prev: NetrwRefresh',
      noremap = true,
      buffer = bufnr,
    })
  end,
})

-- Automatically trim trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Trim trailing whitespace on save',
  group = vim.api.nvim_create_augroup('trim-whitespace', { clear = true }),
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Disable line numbers in terminal mode
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  desc = 'Disable line numbers in terminal mode',
  group = vim.api.nvim_create_augroup('terminal-settings', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Set spell checking for certain file types
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Enable spell checking for text and markdown files',
  group = vim.api.nvim_create_augroup('spellcheck', { clear = true }),
  pattern = { '*.txt', '*.md' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Equalize window dimensions across all tabs when Neovim window is resized
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Equalize window dimensions across all tabs on resize',
  group = vim.api.nvim_create_augroup('window-resize', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- open a terminal buffer in a split on startup
-- vim.api.nvim_create_autocmd('VimEnter', {
--   desc = 'Open a terminal in a split on startup in a clean session',
--   group = vim.api.nvim_create_augroup('startup-terminal', { clear = true }),
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
--   desc = 'Setup a minimal statusline for markdown and text files',
--   group = vim.api.nvim_create_augroup('minimal-statusline', { clear = true }),
--   pattern = {'markdown', 'text'},
--   callback = function()
--     vim.wo.statusline = '%f - word count: %w'
--   end,
-- })
