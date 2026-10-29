local M = {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    max_lines = 3, -- scrolloff in options.lua reserves 3 lines for this
    separator = "─",
  },
}

return M
