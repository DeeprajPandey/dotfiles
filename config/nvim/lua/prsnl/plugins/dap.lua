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
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
    },
  },
}

function M.config(_, opts)
  local dap = require 'dap'
  local ui_ok, dapui = pcall(require, 'dapui')

  if not ui_ok then return end
  -- dap.listeners.before.attach['dapui_config'] = dapui.open
  -- dap.listeners.before.launch['dapui_config'] = dapui.open
  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.after.event_terminated['dapui_config'] = dapui.close
  dap.listeners.after.event_exited['dapui_config'] = dapui.close
end

return M
