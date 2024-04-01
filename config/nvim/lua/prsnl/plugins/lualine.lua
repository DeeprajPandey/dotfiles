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
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { 'filename', 'lsp_progress' },
      lualine_x = { 'diagnostics', 'fileformat', 'encoding', 'filetype', 'filesize' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = { 'fzf', 'fugitive', 'lazy', 'mason', 'man', 'oil', 'nvim-dap-ui', 'trouble' },
  },
}

return M

