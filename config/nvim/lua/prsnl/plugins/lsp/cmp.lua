M = {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',     -- source for builtin lsp client
    'hrsh7th/cmp-buffer',       -- source for text in buffer
    'hrsh7th/cmp-path',         -- source for filesystem paths
    'hrsh7th/cmp-cmdline',      -- source for vim cmdline
    {
      'L3MON4D3/LuaSnip',       -- snippet engine
      -- (optional) for regex support in snippets
      build = ( function()
        if vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end
      )(),
      dependencies = {
        {
          'rafamadriz/friendly-snippets', -- useful snippets
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip', -- autocompletions
  },
}

function M.config(_, opts)
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  luasnip.config.setup {}

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = { completeopt = 'menu,menuone,noinsert' },
    window = {
      completion = cmp.config.window.bordered({
        -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
      }),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      -- ref: https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      -- select [n]ext / [p]revious item
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),

      -- scroll documentation window [b]ack / [f]orward
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),

      -- confirm ([y]es) completion
      -- (auto-import if LSP supports it, expand snippets if LSP sent a snippe)
      -- set `select` to `false` to only confirm explicitly selected items
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),

      -- manually trigger completion - usually not needed
      ['<C-Space>'] = cmp.mapping.complete(),

      -- <C-h> & <C-l> to jump b/w snippet expansion locations
      ['<C-l>'] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { 'i', 's' }),
      ['<C-h>'] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
    },
    {
      { name = 'buffer' },
    }),
  })

  -- completions for `/` & `?` searches: buffer source
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  -- completions for `:` command mode: cmdline and path source
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    },
    {
      {
        name = 'cmdline',
        option = { ignore_cmds = {'Man', '!' } },
      },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
end

return M

