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
      lsp_zero.on_attach(function(_client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr}) -- add lsp-zero defaults

        -- Custom lsp mappings
        -- See this for default: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#lsp-actions
        local opts = {buffer = bufnr}
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'tsserver',
          'yamlls',
          'eslint',
          'mypy'
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
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'}
    },

    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()
      local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

      -- Configure LuaSnip
      local luasnip = require('luasnip')

      -- trigger update of active node's dependents on every change
      luasnip.config.set_config({
        history = true,
        update_events = 'TextChanged,TextChangedI'
      })
      -- add framework snippets (not enabled by default)
      -- see: https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
      luasnip.filetype_extend("vue", {"vue"})

      -- if not within snippet, unlink snip in favour of performance
      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if 
            require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
          {name = 'nvim_lua'},
          {name = 'luasnip'}
        },
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          -- confirm selection. Set to `false` to only confirm explicitly selected items.
          ['<C-y>'] = cmp.mapping.confirm({select = true}),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

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
        }),
        snippet = {
          expand = function (args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered()
        }
      })
    end
  },

}

