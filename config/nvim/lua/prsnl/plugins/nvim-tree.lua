M = {
  'nvim-tree/nvim-tree.lua',
  event = 'VimEnter',
  opts = {
    sort = {
      sorter = 'case_sensitive',
    },
    view = {
      width = 35,
      relativenumber = true,
    },
    -- change folder arrow icons
    renderer = {
      group_empty = true,
      indent_markers = {
        enable = true,
      },
      icons = {
        glyphs = {
          folder = {
            arrow_closed = '', -- arrow when folder is closed
            arrow_open = '', -- arrow when folder is open
          },
        },
      },
    },
    -- disable window_picker for
    -- explorer to work well with
    -- window splits
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
    filters = {
      custom = { '.DS_Store' },
    },
    git = {
      ignore = false,
    },
  }
}

function M.config(_, opts)
  local nvimtree = require('nvim-tree')
  local api = require 'nvim-tree.api'

  -- keep config concise
  local keymap = vim.keymap

  -- change color for arrows in tree to light blue
  vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
  vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

  local function my_on_attach(bufnr)
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  end

  -- set up custom mappings to be enabled within this buffer
  M.opts.on_attach = my_on_attach

  -- setup nvim-tree with updated opts
  nvimtree.setup(opts)

  -- set global keymaps
  keymap.set('n', '<C-e>', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer on current file', noremap = true, silent = true }) -- toggle file explorer on current file
  keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer', noremap = true, silent = true }) -- collapse file explorer
  keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer', noremap = true, silent = true }) -- refresh file explorer
end

return M
