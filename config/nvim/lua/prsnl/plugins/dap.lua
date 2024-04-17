M = {
  'mfussenegger/nvim-dap',
  keys = {
    {
      '<leader>d<space>',
      function() require('dap').continue() end,
      remap = false,
      desc = '[D]AP: Continue or start debugging'
    },
    {
      '<leader>db',
      function() require('dap').toggle_breakpoint() end,
      remap = false,
      desc = '[D]AP: Toggle [b]reakpoint'
    },
  },
}

function M.config(_, opts)
end

return M
