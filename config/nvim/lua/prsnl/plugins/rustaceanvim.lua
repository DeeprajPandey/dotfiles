local M = {
  "mrcjkb/rustaceanvim",
  version = "^9",
  ft = "rust",
}

function M.opts()
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
      local ra = require("rustaceanvim.config.server")

      return ra.load_rust_analyzer_settings(project_root, {
        settings_file_pattern = "rust-analyzer.json",
        default_settings = rust_analyzer_settings,
      })
    end,
  }

  return {
    tools = {
      enable_clippy = false,
    },
    server = server,
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
