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
          separator = '',
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
          separator = '',
        },
      },
      lualine_z = { 'location', 'progress' },
    },
    extensions = { 'fzf', 'fugitive', 'lazy', 'mason', 'man', 'nvim-dap-ui', 'trouble' },
  },
}

function M.config(_, opts)
  -- lsp active clients
  local function get_active_lsp_clients()
    local active_clients = vim.lsp.get_active_clients()
    local client_names = {}
    for _, client in pairs(active_clients or {}) do
      local buf = vim.api.nvim_get_current_buf()
      -- only return attached buffers
      if vim.lsp.buf_is_attached(buf, client.id) then
        table.insert(client_names, client.name)
      end
    end

    if not vim.tbl_isempty(client_names) then
      table.sort(client_names)
    end
    return client_names
  end

  local function get_active_clients_str()
    local clients = get_active_lsp_clients()
    local client_str = ''

    if #clients < 1 then
      return
    end

    for i, client in ipairs(clients) do
      client_str = client_str .. client
      if i < #clients then
        client_str = client_str .. ', '
      end
    end

    return client_str
  end

  -- add lsp active clients fn to lualine y
  vim.list_extend(opts.sections.lualine_y, { get_active_clients_str })
  print(get_active_clients_str())

  require('lualine').setup(opts)
end

return M
