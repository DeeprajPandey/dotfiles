-- [[ Autocommands ]]
-- Highlight when yanking (copying) text; ref: `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
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

