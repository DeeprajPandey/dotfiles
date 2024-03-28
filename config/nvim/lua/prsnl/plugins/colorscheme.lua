local M = {
  -- 1
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    opts = {
      -- styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'
      style = 'night',
      transparent = true,
      styles = {
        keywords = { italic = true },
        sidebars = 'transparent',
        floats = 'transparent',
      },
      lualine_bold = true,
    }
  },
  -- 2
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', },
  -- 3
  { 'rebelot/kanagawa.nvim', name = 'kanagawa', },
  -- 4
  { 'EdenEast/nightfox.nvim', name = 'nightfox', },
  -- 5
  { 'savq/melange-nvim', name = 'melange', },
  -- 6
  -- source: https://github.com/thanhvule0310/dotfiles/blob/main/nvim/lua/v/plugins/catppuccin.lua
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      integration_default = false,
      integrations = {
        aerial = true,
        alpha = true,
        barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          inlay_hints = { background = true },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        navic = { enabled = true, custom_bg = 'lualine' },
        neogit = true,
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        vimwiki = true,
        which_key = true,
      },
      highlight_overrides = {
        all = function(colors)
          return {
            NormalFloat = { bg = colors.base },
            Pmenu = { bg = colors.mantle, fg = "" },
            PmenuSel = { bg = colors.surface0, fg = "" },
            CursorLineNr = { fg = colors.text },
            LineNr = { fg = colors.surface1 },
            FloatBorder = { bg = colors.base, fg = colors.surface0 },
            VertSplit = { bg = colors.base, fg = colors.surface0 },
            WinSeparator = { bg = colors.base, fg = colors.surface0 },
            LspInfoBorder = { link = "FloatBorder" },
            YankHighlight = { bg = colors.surface2 },

            CmpItemMenu = { fg = colors.surface2 },

            GitSignsChange = { fg = colors.peach },

            NeoTreeDirectoryIcon = { fg = colors.subtext1 },
            NeoTreeDirectoryName = { fg = colors.subtext1 },
            NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
            NeoTreeGitConflict = { fg = colors.red },
            NeoTreeGitDeleted = { fg = colors.red },
            NeoTreeGitIgnored = { fg = colors.overlay0 },
            NeoTreeGitModified = { fg = colors.peach },
            NeoTreeGitStaged = { fg = colors.green },
            NeoTreeGitUnstaged = { fg = colors.red },
            NeoTreeGitUntracked = { fg = colors.green },
            NeoTreeIndent = { link = "IblIndent" },
            NeoTreeNormal = { bg = colors.mantle },
            NeoTreeNormalNC = { bg = colors.mantle },
            NeoTreeRootName = { fg = colors.subtext1, style = { "bold" } },
            NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
            NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
            NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
            NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
            NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },

            TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
            TelescopePreviewNormal = { bg = colors.crust },
            TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
            TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
            TelescopePromptNormal = { bg = colors.surface0 },
            TelescopePromptPrefix = { bg = colors.surface0 },
            TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
            TelescopeSelection = { bg = colors.surface0 },

            WhichKeyFloat = { bg = colors.mantle },

            IblIndent = { fg = colors.surface0 },
            IblScope = { fg = colors.overlay0 },

            MasonNormal = { bg = colors.mantle },
            MasonMutedBlock = { link = "CursorLine" },

            LazyNormal = { bg = colors.mantle },
          }
        end,
        latte = function(colors)
          return {
            LineNr = { fg = colors.surface1 },

            IblIndent = { fg = colors.mantle },
            IblScope = { fg = colors.surface1 },
          }
        end,
      },
    },
  },
}

M[6].lazy = false
M[6].priority = true
M[6].config = function(_, opts)
  -- substitution: `.,+1s/tokyonight/catppuccin/g`
  require('catppuccin').setup(opts)
  vim.cmd.colorscheme 'catppuccin'

  -- vim.cmd.colorscheme 'nightfly'

  -- vim.cmd.colorscheme 'melange'
  -- vim.opt.termguicolors = true

  -- vim.cmd.hi 'Comment gui=none'
end

return M

