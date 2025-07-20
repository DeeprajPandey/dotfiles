M = {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    {
      '<c-h>',
      '<cmd><C-U>TmuxNavigateLeft<cr>',
      remap = false,
      desc = 'Move cursor to the left tmux pane',
    },
    {
      '<c-j>',
      '<cmd><C-U>TmuxNavigateDown<cr>',
      remap = false,
      desc = 'Move cursor to the lower tmux pane',
    },
    {
      '<c-k>',
      '<cmd><C-U>TmuxNavigateUp<cr>',
      remap = false,
      desc = 'Move cursor to the upper tmux pane',
    },
    {
      '<c-l>',
      '<cmd><C-U>TmuxNavigateRight<cr>',
      remap = false,
      desc = 'Move cursor to the right tmux pane',
    },
    {
      '<c-\\>',
      '<cmd><C-U>TmuxNavigatePrevious<cr>',
      remap = false,
      desc = 'Move to the previous active pane',
    },
  },
}

return M
