M = {
  'mrcjkb/rustaceanvim',
  version = '^4',
  ft = 'rust',
}

-- ref: https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#using-codelldb-for-debugging
-- ref: https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/rust/init.lua
function M.opts()
  local adapter
  local success, package = pcall(function() return require("mason-registry").get_package "codelldb" end)
  local cfg = require "rustaceanvim.config"

  if success then
    local package_path = package:get_install_path()
    local codelldb_path = package_path .. "/codelldb"
    local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"
    local this_os = vim.loop.os_uname().sysname

    -- path is different on windows
    if this_os:find "Windows" then
      codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
      liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
    else
      -- liblldb extension is .so for linux and .dylib for macOS
      liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    end
    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
  else
    adapter = cfg.get_codelldb_adapter()
  end

  local server = {
    settings = function(project_root, default_settings)
      local rust_analyzer_settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = {
              "--no-deps",
            },
          },
          assist = {
            importEnforceGranularity = true,
            importPrefix = "crate",
          },
          completion = {
            postfix = {
              enable = false,
            },
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true,
            },
          },
        },
      }
      local ra = require 'rustaceanvim.config.server'

      return ra.load_rust_analyzer_settings(project_root, {
        settings_file_pattern = 'rust-analyzer.json',
        default_settings = rust_analyzer_settings,
      })
    end
  }

  return {
    tools = {
      enable_clippy = false,
    },
    server = server,
    dap = {
      adapter = adapter,
    },
  }
end

function M.config(_, opts)
  -- mason-lspconfig assumes we are using nvim-lspconfig.rust_analyzer. Explicitly return non for this to prevent
  -- two instances of rust_analyzer LSP servers for rust buffers
  -- require('mason-lspconfig').setup_handlers {
  --   ['rust_analyzer'] = function() end,
  -- }

  vim.g.rustaceanvim = opts
end

return M
-- M = {
--   'simrat39/rust-tools.nvim',
--   dependencies = { 'neovim/nvim-lspconfig' },
--   ft = 'rust',
--   keys = {
--     { '<leader>re',  vim.cmd.RustExpandMacro,      desc = '[R]ust [E]xpand macro' },
--     { '<leader>rc',  vim.cmd.RustOpenCargo,        desc = '[R]ust Open [C]argo.toml' },
--     { '<leader>rp',  vim.cmd.RustParentModule,     desc = '[R]ust [P]arent module' },
--     { '<leader>rh',  vim.cmd.RustHoverActions,     desc = '[R]ust [H]over actions' },
--     { '<leader>rg',  vim.cmd.RustViewCrateGraph,   desc = '[R]ust View Create [G]raph' },
--     { '<leader>rD',  vim.cmd.RustOpenExternalDocs, desc = '[R]ust Open External [D]ocs' },
--     { '<leader>rr',  vim.cmd.RustRunnables,        desc = 'Open [R]ust [R]unnables' },
--     { '<leader>rca',  vim.cmd.RustCodeAction,       desc = '[R]ust [C]ode [A]ction Groups' },
--     { '<leader>rd',  vim.cmd.RustDebuggables,      desc = '[R]ust [d]ebug' },
--   },
--   opts = {
--     tools = {
--       -- on_initialized = nil,
--       on_initialized = function()
--         vim.api.nvim_create_autocmd(
--           { 'BufEnter', 'CursorHold', 'InsertLeave', 'BufWritePost', 'InsertEnter' },
--           {
--             group = vim.api.nvim_create_augroup('InitializeRustAnalyzer', { clear = true }),
--             pattern = { '*.rs' },
--             callback = function()
--               vim.lsp.codelens.refresh()
--             end,
--           }
--         )
--       end,
--       reload_workspace_from_cargo_toml = true,
--       inlay_hints = {
--         auto = true,
--         only_current_line = false,
--         show_parameter_hints = true,
--         parameter_hints_prefix = ' <- ',
--         other_hints_prefix = ' => ',
--         max_len_align = false,
--         max_len_align_padding = 1,
--         right_align = false,
--         right_align_padding = 7,
--         highlight = 'Comment',
--       },
--     },
--   },
-- }
