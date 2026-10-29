local M = {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "[U]ndotree toggle" },
  },
}

return M
