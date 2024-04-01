M = {
  'nvim-lualine/lualine.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'arkav/lualine-lsp-progress',
  },
  opts = {
    options = {
      --[[
      section_separators = { left = '', right = '' },
      component_separators = { left = '▏', right = '▏' },
      component_separators = { left = '', right = '' },
      ]]
      component_separators = { left = '|', right = '|' },
      globalstatus = true,
    },
    --[[ Available components
      `branch` (git branch)
      `buffers` (shows currently available buffers)
      `diagnostics` (diagnostics count from your preferred source)
      `diff` (git diff status)
      `encoding` (file encoding)
      `fileformat` (file format)
      `filename`
      `filesize`
      `filetype`
      `hostname`
      `location` (location in file in line:column format)
      `mode` (vim mode)
      `progress` (%progress in file)
      `searchcount` (number of search matches when hlsearch is active)
      `selectioncount` (number of selected characters or lines)
      `tabs` (shows currently available tabs)
      `windows` (shows currently available windows) ]]
    sections = {
      lualine_a = {
        {
          'fileformat',
          icon_only = true,
          padding = { left = 1, right = 0 },
          separator = ''
        },
        'mode',
      },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        { 'filename', path = 1, newfile_status = true },
        'lsp_progress',
      },
      lualine_x = { 'diagnostics', 'encoding', 'filetype', 'filesize' },
      lualine_y = {
        {
          'searchcount',
          timeout = 3500,
          separator = ''
        }
      },
      lualine_z = { 'location', 'progress' },
    },
    extensions = { 'fzf', 'fugitive', 'lazy', 'mason', 'man', 'nvim-dap-ui', 'trouble' },
  },
}

return M

