local M = {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/playground',
  },
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'go',
      'gleam',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'query',
      'rust',
      'vim',
      'vimdoc',
    },

    sync_install = false,
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<space>', -- maps in normal mode to init the node/scope selection with space
        node_incremental = '<space>', -- increment to the upper named parent
        node_decremental = '<bs>', -- decrement to the previous node
        scope_incremental = '<tab>', -- increment to the upper scope (as defined in locals.scm)
      },
    },
    -- experimental
    indent = { enable = true },
    autopairs = {
      enable = true,
    },
    context = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['iB'] = '@block.inner',
          ['aB'] = '@block.outer',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']]'] = '@function.outer',
        },
        goto_next_end = {
          [']['] = '@function.outer',
        },
        goto_previous_start = {
          ['[['] = '@function.outer',
        },
        goto_previous_end = {
          ['[]'] = '@function.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>sn'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>sp'] = '@parameter.inner',
        },
      },
    },
  },
}

function M.config(_, opts)
  local configs = require('nvim-treesitter.configs')

  -- disable specific languages
  -- opts.highlight.disable = { 'c', 'rust' },
  -- OR use a function
  -- disable highlights on files larger than 850 KB
  function opts.highlight.disable(lang, buf)
    local max_filesize = 850 * 1024 -- 850 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
    end
  end

  -- set up treesitter
  configs.setup(opts)
end

return M
