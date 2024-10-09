M = {
  -- <Tab> to select items.
  -- zn to keep selected items.
  -- zN to filter selected items.
  -- zf to fuzzy search items.
  --
  -- <Ctrl-f> scroll down
  -- <Ctrl-b> scroll up
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  dependencies = {
    {
      'junegunn/fzf',
      build = function()
        vim.fn['fzf#install']()
      end,
    },
    { 'nvim-treesitter/nvim-treesitter' },
  },
}

return M
