M = {
  "dstein64/vim-startuptime",
  -- lazy-load on a command
  cmd = "StartupTime",
}

function M.init()
  vim.g.startuptime_tries = 10
end

return M

