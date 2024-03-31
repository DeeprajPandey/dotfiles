local M = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    "nvim-treesitter/playground"
  },
  opts = {
    ensure_installed = {"c", "lua", "vim", "vimdoc", "query" },

    sync_install = false,
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    -- experimental
    indent = { enable = true },
  },
}

function M.config(_, opts)
  local configs = require("nvim-treesitter.configs")

  -- disable specific languages
  -- opts.highlight.disable = { "c", "rust" },
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

