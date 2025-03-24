M = {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- source for builtin lsp client
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for filesystem paths
    'hrsh7th/cmp-cmdline', -- source for vim cmdline
    {
      'L3MON4D3/LuaSnip', -- snippet engine
      -- (optional) for regex support in snippets
      build = (function()
        if vim.fn.executable('make') == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      }, -- useful snippets
    },
    'saadparwaiz1/cmp_luasnip', -- autocompletions
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-calc',
    'SergioRibera/cmp-dotenv',
    -- {
    --   'Exafunction/codeium.nvim',
    --   enabled = false,
    --   dependencies = { 'nvim-lua/plenary.nvim' },
    --   opts = {},
    -- },
    -- { "zbirenbaum/copilot-cmp", opts = {}, dependencies = { "zbirenbaum/copilot.lua" } },
    'roginfarrer/cmp-css-variables',
    'pontusk/cmp-sass-variables',
    {
      'vrslev/cmp-pypi',
      dependencies = { 'nvim-lua/plenary.nvim' },
      event = { 'BufRead pyproject.toml', 'BufRead requirements.txt', 'BufRead requirements_dev.txt' },
    },
    {
      'micangl/cmp-vimtex',
      keys = {
        i = {
          '<C-s>',
          function()
            require('cmp_vimtex.search').perform_search({ engine = 'google' })
          end,
          desc = '[s]earch selected bibtex entry',
        },
      },
      opt = {},
    },
  },
}

-- ref: CosmicNvim
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

function M.config(_, opts)
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local kind_icons = {
    Text = '󰉿',
    Method = '󰆧',
    Function = '󰊕',
    Constructor = '',
    Field = '󰜢',
    Variable = '󰀫',
    Class = '󰠱',
    Interface = '',
    Module = '',
    Property = '󰜢',
    Unit = '󰑭',
    Value = '󰎠',
    Enum = '',
    Keyword = '󰌋',
    Snippet = '',
    Color = '󰏘',
    File = '󰈙',
    Reference = '󰈇',
    Folder = '󰉋',
    EnumMember = '',
    Constant = '󰏿',
    Struct = '󰙅',
    Event = '',
    Operator = '󰆕',
    TypeParameter = '',
    -- Copilot = "",
    -- Codeium = '',
  }

  -- Configure luasnip
  -- trigger update of active node's dependents on every change
  luasnip.config.set_config({
    history = true,
    update_events = 'TextChanged,TextChangedI',
  })
  -- add framework snippets (not enabled by default)
  -- ref: https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
  luasnip.filetype_extend('vue', { 'vue' })

  -- if not within snippet, unlink snip in favour of performance
  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      if
        require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
      then
        require('luasnip').unlink_current()
      end
    end,
  })

  -- Configure nvim-cmp with sources and keymaps
  cmp.setup({
    performance = {
      debounce = 100,
      throttle = 80,
      fetching_timeout = 80,
    },
    preselect = cmp.PreselectMode.None, -- do not auto-select items, need <CR> for newline otherwise
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    -- to enable preselection, remove `noselect`
    completion = { completeopt = 'menu,menuone,noinsert,noselect' },
    window = {
      completion = cmp.config.window.bordered({
        -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None'
      }),
      documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'luasnip' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'calc' },
      { name = 'dotenv' },
      -- { name = 'copilot' },
      -- { name = 'codeium' },
      -- { name = 'crates' },
      { name = 'css-variables' },
      { name = 'cmp-sass-variables' },
      { name = 'pypi' },
      { name = 'vimtex' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      fields = { 'abbr', 'kind', 'menu' },
      format = function(entry, vim_item)
        local short_name = {
          calc = '[calc]',
          nvim_lsp = '[LSP]', -- 'λ'
          nvim_lua = '[lua]', -- 'Π'
          path = '[path]', -- ''
          -- copilot = '[copilot]',
          -- codeium = '[codeium]',
          luasnip = '[snip]', -- '⋗'
          pypi = '[pypi]',
          env = '[env]',
          buffer = '[buf]', -- 'Ω'
          -- can't overwrite cmp-vimtex's additional info
          vimtex = '[VimTeX]' .. (vim_item.menu ~= nil and vim_item.menu or ''),
        }
        local menu_name = short_name[entry.source.name] or entry.source.name

        vim_item.kind = kind_icons[vim_item.kind]
        vim_item.menu = string.format('[%s]', menu_name)
        return vim_item
      end,
      expandable_indicator = true,
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

      -- we have turned off preselection (noselect). now, only accept selected entry.
      -- visual cues match behaviour.
      ['<CR>'] = cmp.mapping.confirm({ select = false }),

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

      -- luasnip_supertab; ref: lsp-zero
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
          -- endofline tab ends up triggering completion menu
          -- elseif has_words_before() then
          --   cmp.complete()
        else
          -- elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),

    experimental = {
      ghost_text = true,
    },
  })

  -- completions for `/` & `?` searches: buffer source
  cmp.setup.cmdline('/', {
    -- use tab-complete
    mapping = cmp.mapping.preset.cmdline({
      ['<Tab>'] = {
        c = function(default)
          if cmp.visible() then
            return cmp.confirm({ select = false })
          end

          default()
        end,
      },
    }),
    sources = {
      { name = 'buffer' },
    },
  })

  -- completions for `:` command mode: cmdline and path source
  cmp.setup.cmdline(':', {
    completion = { completeopt = 'menu,menuone,noinsert' },
    -- use tab-complete
    mapping = cmp.mapping.preset.cmdline({
      ['<Tab>'] = {
        c = function(default)
          if cmp.visible() then
            return cmp.confirm({ select = false })
          end

          default()
        end,
      },
    }),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      {
        name = 'cmdline',
        option = { ignore_cmds = { 'Man', '!' } },
      },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })

  -- buffer-specific completions for rust crate version in Cargo.toml files
  vim.api.nvim_create_autocmd('BufRead', {
    desc = 'Lazy load crate version completions when opening Cargo.toml',
    group = vim.api.nvim_create_augroup('CmpSourceCargo', { clear = true }),
    pattern = 'Cargo.toml',
    callback = function()
      cmp.setup.buffer({ sources = { { name = 'crates' } } })
    end,
  })
end

return M
