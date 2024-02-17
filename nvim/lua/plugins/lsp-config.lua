-- Based on the helpful guides put up by github.com/VonHeikemen
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/lazy-loading-with-lazy-nvim.md
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/configuration-templates.md#slightly-more-opinionated-lua-configuration
return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup({})
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },

    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()
      local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

      cmp.setup({
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          -- confirm selection
          ['<C-y>'] = cmp.mapping.confirm({select = true}),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

          -- navigate completion menu (with autocomplete)
          ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item(cmp_select_opts)
            else
              cmp.complete()
            end
          end),
          ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item(cmp_select_opts)
            else
              cmp.complete()
            end
          end),

          -- toggle completion menu
          ['<C-e>'] = cmp_action.toggle_completion(),

          -- scroll documentation window
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),

          -- jump b/w snippet placeholders
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        })
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'tsserver',
          'yamlls',
          'eslint',
          'black',
          'mypy',
          'ruff',
          'shellcheck'
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })

      -- Older Manual Config

      --      local lspconfig = require("lspconfig")
      --      lspconfig.lua_ls.setup {}
      --      lspconfig.typos_lsp.setup {}
      --
      --      -- Use LspAttach autocommand to only map the following keys
      --      -- after the language server attaches to the current buffer
      --      vim.api.nvim_create_autocmd('LspAttach', {
      --        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      --        callback = function(ev)
      --          -- Enable completion triggered by <c-x><c-o>
      --          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      --
      --          -- Buffer local mappings.
      --          -- See `:help vim.lsp.*` for documentation on any of the below functions
      --          local opts = { buffer = ev.buf }
      --          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      --          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      --          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      --          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      --          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      --          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      --          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      --          vim.keymap.set('n', '<leader>wl', function()
      --            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      --          end, opts)
      --          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      --          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      --          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      --          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      --          vim.keymap.set('n', '<leader>f', function()
      --            vim.lsp.buf.format { async = true }
      --          end, opts)
      --        end,
      --      })

    end
  }
}

