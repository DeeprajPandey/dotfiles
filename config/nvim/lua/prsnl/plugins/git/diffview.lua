M = {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen' },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
    hooks = {
      diff_buf_read = function(bufnr)
        vim.b[bufnr].view_activated = false
      end,
    },
  },
  specs = {
    {
      'NeogitOrg/neogit',
      optional = true,
      opts = { integrations = { diffview = true } },
    },
  },
}

return M
