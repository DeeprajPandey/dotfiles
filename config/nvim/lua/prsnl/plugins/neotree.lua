M = {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  keys = {
    {
      '<C-n>',
      function()
        require('neo-tree.command').execute({
          toggle = true,
        })
      end,
      desc = '[Neotree] Toggle',
    },
  },
  cmd = { 'Neotree' },
  opts = {
    close_if_last_window = true,
    popup_border_style = 'single',
    enable_git_status = true,
    enable_diagnostics = true,
    enable_normal_mode_for_inputs = false, -- enable normal mode for input dialogs
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- skip windows with these file/buffers
    sort_case_insensitive = false,
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        with_expanders = true,
        expander_collapsed = '', -- ''
        expander_expanded = '', -- ''
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰜌',
        -- fallback w/o nvim-web-devicons
        default = '*',
        highlight = 'NeoTreeFileIcon'
      },
      modified = {
        symbol = '●',
        -- fallback
        default = '[+]',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- change type
          added = '',      -- '✚', but git_status_colors gives same info
          modified = '',   -- '', but^
          deleted = '',    -- '✖', only in git_status source
          renamed = '',    -- '󰁕', only in git_status source
          -- status type
          untracked = '',   -- ''
          ignored = '',    -- ''
          unstaged = '',   -- '󰄱'
          staged = '',     -- ''
          conflict = '',   -- ''
        },
      },
      file_size = {
        enabled = true,
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        required_width = 122, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = true,
        required_width = 110, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
    -- custom commands available globally
    commands = {},
    window = {
      position = 'left',
      width = 34,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['h'] = 'close_node',
        ['l'] = 'open',
        ['L'] = 'open_vsplit',
        ['S'] = 'open_split',
        ['d'] = 'trash',
        ['<C-d>'] = 'delete',
        ['a'] = {
          'add',
          -- this command supports BASH style brace expansion ('x{a,b,c}' -> xa,xb,xc). see `:h neo-tree-file-actions` for details
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = 'relative' -- 'none', 'relative', 'absolute'
          }
        },
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = {
          'copy',
          config = {
            show_path = 'relative' -- 'none', 'relative', 'absolute'
          }
        },
        ['m'] = {
          'move',
          config = {
            show_path = 'relative' -- 'none', 'relative', 'absolute'
          }
        },
        ['q'] = 'close_window',
        ['R'] = 'refresh',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
        ['i'] = 'show_file_details',
      },
    },
    filesystem = {
      commands = {
        trash = function(state)
          local inputs = require('neo-tree.ui.inputs')
          local path = state.tree:get_node().path
          local msg = 'Are you sure you want to trash ' .. path
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system({ 'trash', vim.fn.fnameescape(path) })
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
        trash_visual = function(state, selected_nodes)
          local inputs = require('neo-tree.ui.inputs')

          local function get_table_length(tbl)
            local len = 0
            for _ in pairs(tbl) do
              len = len + 1
            end
            return len
          end

          local count = get_table_length(selected_nodes)
          local msg = 'Are you sure you want to trash ' .. count .. ' files ?'
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system({ 'trash', vim.fn.fnameescape(node.path) })
            end
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      components = {
        name = function(config, node, state)
          local cc = require('neo-tree.sources.common.components')
          local result = cc.name(config, node, state)
          if node:get_depth() == 1 then
            result.text = string.gsub(state.path, '(.*[/\\])(.*)', '%2')
          end
          return result
        end,
      },
    },
    source_selector = {
      winbar = true,
      sources = {
        { source = 'filesystem', display_name = '   Files ' },
        { source = 'buffers', display_name = '   Bufs ' },
        { source = 'git_status', display_name = '   Git ' },
      },
    },
    event_handlers = {
      {
        event = 'file_opened',
        handler = function()
          require('neo-tree.command').execute({ action = 'close' })
        end,
      },
      {
        event = 'neo_tree_window_after_open',
        handler = function(args)
          if args.position == 'left' or args.position == 'right' then
            vim.cmd('wincmd =')
          end
        end,
      },
      {
        event = 'neo_tree_window_after_close',
        handler = function(args)
          if args.position == 'left' or args.position == 'right' then
            vim.cmd('wincmd =')
          end
        end,
      },
    },
  },
}

return M

