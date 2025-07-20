M = {
  'mbbill/undotree',
  event = 'VimEnter',
}

function M.config(_, opts)
  vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
end

return M
