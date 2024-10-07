M = {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo', 'FormatEnable', 'FormatDisable' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    notify_on_error = true,
    notify_no_formatters = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt = 'fallback'
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
        lsp_format_opt = 'never'
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        lsp_format_opt = 'never'
      end
      -- Disable autoformat for files in a certain path
      if bufname:match('/node_modules/') then
        lsp_format_opt = 'never'
      end

      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      -- install manually
      go = { 'gofumpt', 'goimports_reviser', 'golines' },
      lua = { 'stylua' },
      python = {
        'ruff_fix', -- To fix lint errors. (ruff with argument --fix)
        'ruff_format', -- To run the formatter. (ruff with argument format)
      },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },
  },
}

function M.config(_, opts)
  require('conform').setup(opts)

  vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
  })

  vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = 'Re-enable autoformat-on-save',
  })
end

return M
