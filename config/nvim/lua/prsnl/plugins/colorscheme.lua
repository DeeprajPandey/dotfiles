local M = {
  -- 1
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    opts = {
      -- styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'
      style = 'night',
      transparent = true,
      styles = {
        keywords = { italic = true },
        sidebars = 'transparent',
        floats = 'transparent',
      },
      lualine_bold = true,
    }
  },
  -- 2
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', },
  -- 3
  { 'rebelot/kanagawa.nvim', name = 'kanagawa', },
  -- 4
  { 'EdenEast/nightfox.nvim', name = 'nightfox', },
  -- 5
  { 'savq/melange-nvim', name = 'melange', },
  -- 6
  { 'catppuccin/nvim', name = 'catppuccin', },
}

M[6].lazy = false
M[6].priority = true
M[6].config = function(_, opts)
  -- substitution: `.,+1s/tokyonight/catppuccin/g`
  require('catppuccin').setup(opts)
  vim.cmd.colorscheme 'catppuccin'

  -- vim.cmd.colorscheme 'nightfly'

  -- vim.cmd.colorscheme 'melange'
  -- vim.opt.termguicolors = true

  -- vim.cmd.hi 'Comment gui=none'
end

return M

