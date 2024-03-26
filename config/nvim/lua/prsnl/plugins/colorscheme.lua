local M = {
  'folke/tokyonight.nvim',
  priority = 1000,
}

function M.init()
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  vim.cmd.colorscheme 'tokyonight-night'

  -- You can configure highlights by doing something like:
  vim.cmd.hi 'Comment gui=none'
end

return M

