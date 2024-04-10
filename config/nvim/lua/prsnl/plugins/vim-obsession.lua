M = {
  'tpope/vim-obsession',
  event = 'VimEnter',
}

function M.config(_, opts)
  local session_dir = vim.fn.expand('~/.vim/vim-sessions')
  vim.fn.mkdir(session_dir, 'p')

  -- set session options
  vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

  local function save_session()
    local cwd = vim.fn.getcwd()
    local default_session_name = cwd:match('([^/]+)$')  -- last part of cwd is dir_name
    local session_name = vim.fn.input('Session name: ', session_dir .. '/' .. 'session.' .. default_session_name .. '.vim', 'file')

    if session_name and #session_name > 0 then
      vim.cmd('Obsession ' .. session_name)
    end
  end

  local function restore_session()
    local cwd = vim.fn.getcwd()
    local default_session_file = cwd:match('([^/]+)$')  -- last part of cwd is dir_file
    local session_file = vim.fn.input('Session file: ', session_dir .. '/' .. 'session.' .. default_session_file .. '.vim', 'file')
    if session_file and #session_file > 0 then
      vim.cmd('source ' .. session_file)
    end
  end

  local nmap = function (keys, func, desc)
    vim.keymap.set('n', keys, func, { desc = desc, noremap = true, silent = true })
  end

  nmap('<leader>os', save_session, '[O]bsession [S]ave')
  nmap('<leader>or', restore_session, '[O]bsession [R]estore')
  nmap('<leader>op', '<cmd>Obsession<CR>', '[O]bsession [P]ause')
  nmap('<leader>ox', '<cmd>Obsession!<CR>', '[O]bsession Close and Delete[x]')
end

return M
