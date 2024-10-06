M = {
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  event = 'LspAttach',
  keys = {
    {
      '<Leader>uD',
      function()
        require('lsp_lines').toggle()
      end,
      desc = 'Toggle virtual diagnostic lines',
    },
  },
  opts = {
    highlight_whole_line = false,
    only_current_line = true,
    autocmds = {
      LspLinesPlugin = {
        {
          event = 'FileType',
          pattern = 'lazy',
          desc = 'Disable plugin when opening `lazy` UI to avoid artifacts',
          callback = function()
            ---@diagnostic disable-next-line: undefined-field
            if not vim.diagnostic.config().virtual_lines then
              return
            end
            require('lsp_lines').toggle()
            vim.b.lsp_lines_temp_disabled_for_lazy_ft = true
          end,
        },
        {
          event = 'BufLeave',
          desc = 'Enable plugin when closing `lazy` UI',
          callback = function(args)
            if vim.bo[args.buf].filetype == 'lazy' and vim.b.lsp_lines_temp_disabled_for_lazy_ft then
              require('lsp_lines').toggle()
            end
          end,
        },
      },
    },
    diagnostics = {
      virtual_text = false,
    },
  },
}

return M
