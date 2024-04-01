M = {
  'nvim-tree/nvim-tree.lua',
  event = 'VimEnter',
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
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
  -- Global variable to keep track of the vsplit window
  _G.vsplit_preview_window = nil

  local nvimtree = require('nvim-tree')
  local api = require 'nvim-tree.api'

  -- keep config concise
  local keymap = vim.keymap

  -- change color for arrows in tree to light blue
  vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
  vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

  local function edit_or_open()
    local node = api.tree.get_node_under_cursor()

    if node.type == 'directory' then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file
      api.node.open.edit()
      -- Close the tree if file was opened
      api.tree.close()
    end
  end

  -- open as vsplit on current node
  -- BUG: this is breaking nvim-tree's internal buffer management due to a custom naming scheme they use
  -- TODO: use nvim-tree api to open preview and update only the window buffer bit
  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.type == 'directory' then
      api.node.open.edit()
      return
    end

    -- store nvim-tree window id to return focus to after opening preview
    -- :: might not need this, api.tree.focus() could work
    local tree_win = vim.api.nvim_get_current_win()


    -- if the vsplit window exists and is valid, use it
    if _G.vsplit_preview_window and vim.api.nvim_win_is_valid(_G.vsplit_preview_window) then
      vim.api.nvim_set_current_win(_G.vsplit_preview_window)
    else
      -- create a new vsplit window and store its window ID
      vim.cmd('vsplit')
      _G.vsplit_preview_window = vim.api.nvim_get_current_win()
    end

    -- open file in the vsplit window
    api.node.open.edit()

    -- Finally refocus on tree if it was lost
    vim.api.nvim_set_current_win(tree_win)
    -- api.tree.focus()
  end

  -- custom on_attach mappings
  local function on_attach_custom_maps(bufnr)
    local function buf_map_opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- clear <C-e> mapping. Don't need to open anything in place. Need C-e for toggle.
    vim.api.nvim_buf_del_keymap(bufnr, 'n', '<C-e>')

    -- intuitive mappings with direction keys
    keymap.set('n', '?', api.tree.toggle_help,  buf_map_opts('Help'))
    keymap.set('n', 'l', edit_or_open,          buf_map_opts('Edit Or Open'))
    keymap.set('n', 'L', vsplit_preview,        buf_map_opts('Vsplit Preview'))
    keymap.set('n', 'h', api.tree.close,        buf_map_opts('Close'))
    keymap.set('n', 'H', api.tree.collapse_all, buf_map_opts('Collapse All'))
  end

  -- set up custom mappings to be enabled within this buffer
  opts.on_attach = on_attach_custom_maps

  -- setup nvim-tree with updated opts
  nvimtree.setup(opts)

  -- set global keymaps
  keymap.set('n', '<C-e>', api.tree.toggle, { desc = 'Toggle file explorer on current file', noremap = true, silent = true }) -- toggle file explorer on current file
end

return M
