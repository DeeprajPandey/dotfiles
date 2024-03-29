local M = {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  tag = '0.1.6',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
      },
      path_display = { 'smart' },
      file_ignore_patterns = { '.spl', 'target/', '*.pdf' }
    },
    pickers = {
      find_files = {
        -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
        find_command = { 'rg', '--files', '--hidden', '--unrestricted' },
      },
    },
  },
}

function M.config(_, opts)
  local telescope = require('telescope')
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local themes = require('telescope.themes')

  opts.defaults.mappings = {
    i = {
      ['<C-enter>'] = 'to_fuzzy_refine',
      ["<C-k>"] = actions.move_selection_previous, -- move to prev result
      ["<C-j>"] = actions.move_selection_next, -- move to next result
      ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
    },
  }
  opts.extensions = {
    ['ui-select'] = { themes.get_dropdown {} }
  }

  telescope.setup(opts)

  pcall(telescope.load_extension, 'fzf')
  pcall(telescope.load_extension, 'ui-select')

  -- set keymaps
  local keymap = vim.keymap

  keymap.set('n', '<C-p>', builtin.git_files, { desc = '[P]roject files tracked by git', noremap = true })
  keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles in cwd', noremap = true })
  keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep in cwd', noremap = true })
  keymap.set('n', '<leader>sw', function(word)
    builtin.grep_string({ search = word})
  end, { desc = '[S]earch current [W]ord in cwd', noremap = true })
  keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps', noremap = true })
  keymap.set('n', '<leader>sm', builtin.man_pages, { desc = '[S]earch [M]an pages', noremap = true })
  keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp tags', noremap = true })
  keymap.set('n', '<leader>sC', builtin.commands, { desc = '[S]earch [C]ommands', noremap = true })
  keymap.set('n', '<leader>sE', builtin.symbols, { desc = '[S]earch [E]mojis', noremap = true })
  keymap.set('n', '<leader>sR', builtin.registers, { desc = '[S]earch [R]egisters', noremap = true })
  keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers', noremap = true })
  keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(themes.get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer', noremap = true })
end

return M

