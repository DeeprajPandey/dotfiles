local M = {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>d<space>",
      function()
        require("dap").continue()
      end,
      remap = false,
      desc = "[D]AP: Continue or start debugging",
    },
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      remap = false,
      desc = "[D]AP: Toggle [b]reakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").toggle_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      remap = false,
      desc = "[D]AP: Set conditional [B]reakpoint",
    },
    {
      "<leader>dL",
      function()
        require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      remap = false,
      desc = "[D]AP: [L]og breakpoint",
    },
    {
      "<leader>dj",
      function()
        require("dap").step_into()
      end,
      remap = false,
      desc = "[D]AP: Step into (vim-motion `[j]`)",
    },
    {
      "<leader>dk",
      function()
        require("dap").step_out()
      end,
      remap = false,
      desc = "[D]AP: Step out (vim-motion `[k]`)",
    },
    {
      "<leader>dl",
      function()
        require("dap").step_over()
      end,
      remap = false,
      desc = "[D]AP: Step over (vim-motion `[l]`)",
    },
    {
      "<leader>dh",
      function()
        require("dap").step_back()
      end, -- some debuggers might not support reverse debugging
      remap = false,
      desc = "[D]AP: Step back (vim-motion `[h]`)",
    },
    {
      "<leader>dr",
      function()
        require("dap").restart()
      end,
      remap = false,
      desc = "[D]AP: Continue or start debugging",
    },
    {
      "<leader>dT",
      function()
        require("dap").terminate()
      end,
      remap = false,
      desc = "[D]AP: [T]erminate",
    },
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
    "williamboman/mason.nvim", -- needs to be loaded before mason-nvim-dap
    "jay-babu/mason-nvim-dap.nvim",
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    -- debuggers
    {
      "mfussenegger/nvim-dap-python",
      ft = "python",
      dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
      },
    },
  },
}

function M.config(_, opts)
  local dap = require("dap")
  local ui_ok, dapui = pcall(require, "dapui")

  if not ui_ok then
    return
  end
  dapui.setup()
  dap.listeners.before.attach["dapui_config"] = dapui.open
  dap.listeners.before.launch["dapui_config"] = dapui.open
  -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.after.event_terminated["dapui_config"] = dapui.close
  dap.listeners.after.event_exited["dapui_config"] = dapui.close

  -- Debug Adapters: mason-nvim-dap handles adapter setup via handlers
  require("mason-nvim-dap").setup({
    ensure_installed = { "python", "codelldb" },
    handlers = {
      function(config)
        -- default handler: auto-configures all installed adapters
        require("mason-nvim-dap").default_setup(config)
      end,
      python = function(config)
        -- use nvim-dap-python for richer python debugging
        require("dap-python").setup()
      end,
    },
  })
end

return M
