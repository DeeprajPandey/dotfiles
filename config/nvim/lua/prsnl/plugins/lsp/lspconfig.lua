local M = {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile", "BufWinEnter" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",

    -- LSP status updates
    { "j-hui/fidget.nvim", opts = {} },
  },
}

function M.config(_, opts)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("prsnl-lsp-attach", { clear = true }),
    callback = function(event)
      -- buffer local keybindings since they only work if language server is active
      local builtin = require("telescope.builtin")

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")  -- to jump back, press <C-t>
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration") -- e.g. header in C
      map("grr", builtin.lsp_references, "[G]oto [R]eferences")
      map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
      map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      -- fuzzy find all symbols in current document
      map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
      map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

      -- highlight references of the word under cursor after a small delay; cleared on move
      -- ref: `:help CursorHold`
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup("prsnl-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("prsnl-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "prsnl-lsp-highlight", buffer = event2.buf })
          end,
        })
      end
    end,
  })

  vim.diagnostic.config({
    virtual_text = true, -- virtual text
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  --  Overrides for lang. server configs
  --  - cmd (table): default init command
  --  - filetypes (table): default list of associated filetypes
  --  - capabilities (table): override fields in capabilities
  --  - settings (table): override the default settings passed when initializing the server.
  -- ref: for `lua_ls`, https://luals.github.io/wiki/settings/
  local servers = {
    -- ref: `:help lspconfig-all`
    bashls = {},
    biome = {},
    clangd = {
      capabilities = {
        offsetEncoding = "utf-16",
      },
    },
    cssls = {},
    emmet_ls = {},
    html = {},
    jsonls = {},
    pyright = {},
    -- gopls = {},
    -- rust_analyzer = {
    --   filetypes = { 'rust' },
    --   root_dir = require('lspconfig').util.root_pattern('Cargo.toml', 'rust-project.json'),
    --   single_file_support = true,
    --   settings = {
    --     ['rust-analyzer'] = {
    --       -- cargo = {
    --       --   allFeatures = true, -- crate autocompletes
    --       -- },
    --       diagnostics = {
    --         enable = true,
    --       }
    --     }
    --   }
    -- },

    lua_ls = {
      -- cmd = {...},
      -- filetypes = { ...},
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          -- toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
          -- do not send any telemetry data
          telemetry = {
            enable = false,
          },
        },
      },
    },
    texlab = {},
    -- typescript lang. plugin, if needed: https://github.com/pmizio/typescript-tools.nvim
    ts_ls = {
      init_options = {
        preferences = {
          -- change to `true` to reduce non-actionable suggestions
          disableSuggestions = false,
        },
      },
    },
  }

  require("mason").setup()

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- debug adapters (configured in dap.lua)
    "codelldb", -- for rustaceanvim
    "debugpy",
    -- formatters (configured in conform.lua)
    "stylua",
    "yamlfmt",
    "prettierd",
  })

  require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- every server gets cmp's capabilities; per-server tables merge on top
  vim.lsp.config("*", { capabilities = capabilities })
  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
  end

  -- mason-lspconfig v2 enables each installed server via vim.lsp.enable()
  require("mason-lspconfig").setup({
    automatic_enable = {
      -- conform runs stylua; rustaceanvim owns rust_analyzer
      exclude = { "stylua", "rust_analyzer" },
    },
  })
end

return M
