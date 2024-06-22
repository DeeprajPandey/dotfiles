M = {
  'neovim/nvim-lspconfig',
  cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
  event = { 'BufReadPre', 'BufNewFile', 'BufWinEnter' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'hrsh7th/cmp-nvim-lsp',

    -- LSP status updates
    { 'j-hui/fidget.nvim', opts = {} },

    -- LSP for nvim config, runtime and plugins
    { 'folke/neodev.nvim', opts = {} },
  },
}

function M.config(_, opts)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('prsnl-lsp-attach', { clear = true }),
    callback = function(event)
      -- buffer local keybindings since they only work if language server is active
      local builtin = require('telescope.builtin')

      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')  -- to jump back, press <C-t>
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') -- e.g. header in C
      map('gr', builtin.lsp_references, '[G]oto [R]eferences')
      map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
      map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>f', function()
        -- never request typescript language server for formatting
        vim.lsp.buf.format({
          async = true,
          filter = function(client) return client.name ~= "tsserver" end
        })
      end, '[F]ormat Document')
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      -- fuzzy find all symbols in current document
      map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
      map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- highlight references of the word under cursor after a small delay; cleared on move
      -- ref: `:help CursorHold`
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup('prsnl-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('prsnl-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'prsnl-lsp-highlight', buffer = event2.buf }
          end,
        })
      end
    end,
  })

  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  vim.diagnostic.config({
    virtual_text = true, -- virtual text
    signs = {
      active = signs,    -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
  })

  -- LSP servers and clients are able to communicate to each other what features they support.
  --  By default, Neovim doesn't support everything that is in the LSP specification.
  --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
  --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

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
        offsetEncoding = 'utf-16',
      },
    },
    cssls = {},
    debugpy = {}, -- for python dap
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
            callSnippet = 'Replace',
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
    tsserver = {},
    yamlfmt = {},
  }

  require('mason').setup()

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'codelldb', -- for rustaceanvim
    'stylua', -- lua formatter
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    automatic_installation = true,
    automatic_setup = true,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        -- override values passed by the server config above
        -- e.g. turn off LSP formatters for certain servers
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

        -- mason-lspconfig assumes we are using nvim-lspconfig.rust_analyzer. Explicitly return non for this to prevent
        -- two instances of rust_analyzer LSP servers for rust buffers
        -- if server_name == 'rust_analyzer' then
        --   server = function() end
        if server_name == 'tsserver' then
          server.init_options = {
            preferences = {
              -- change to `true` to reduce non-actionable suggestions
              disableSuggestions = false,
            }
          }
          -- IMP: don't need this. Filter in formatting keymap skips tsserver
          -- function server.on_attach(client)
          --   -- this is important, otherwise tsserver will format ts/js
          --   -- files which we *really* don't want.
          --   client.server_capabilities.documentFormattingProvider = false
          -- end
        end
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end

return M
