-- masks .env values on screen; :CloakToggle reveals them
local M = {
  "laytan/cloak.nvim",
  event = "BufReadPre .env*",
  cmd = { "CloakToggle", "CloakPreviewLine" },
  opts = {},
}

return M
