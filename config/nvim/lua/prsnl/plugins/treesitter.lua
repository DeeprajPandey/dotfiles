-- TODO: look into treesitter-textobjects, treesitter-context, and incremental selection
local M = {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,       -- main does not support lazy-loading
  build = ':TSUpdate',
}

local parsers = {
  'bash',
  'c',
  'css',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

function M.config()
  require('nvim-treesitter').install(parsers)

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter highlight and indent when a parser exists',
    group = vim.api.nvim_create_augroup('prsnl-treesitter', { clear = true }),
    callback = function(event)
      -- highlighting very large files stalls the UI
      local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(event.buf))
      if stats and stats.size > 850 * 1024 then
        return
      end
      if pcall(vim.treesitter.start, event.buf) then
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M

