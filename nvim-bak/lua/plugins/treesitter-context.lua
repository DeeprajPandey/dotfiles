return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  init = function()
    vim.cmd.highlight("TreesitterContext guifg=#504944 ctermfg=239 guibg=#1e1e2e ctermbg=252 gui=NONE cterm=NONE")
    vim.cmd.highlight("TreesitterContextBottom gui=None")
    vim.cmd.highlight("TreesitterContextLineNumberBottom gui=None guifg=#89b4fa guibg=#1e1e2e")
  end,
  opts = {
    enable = true,
    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 4, -- Maximum number of lines to show for a single context
    trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,          -- alternatives: ▁ ─ ▄ (credits: akinsho)
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  }
}
