M = {
  'tpope/vim-obsession',
  event = 'VimEnter',
}

function M.config(_, opts)
  local session_dir = vim.fn.expand('~/.vim/vim-sessions')
  vim.fn.mkdir(session_dir, 'p')

  -- set session options
  vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

  local function get_default_session_file()
    local cwd = vim.fn.getcwd()
    local dir_name = cwd:match('([^/]+)$') -- last part of cwd is dir_name
    return session_dir .. '/session.' .. dir_name .. '.vim'
  end

  local function load_session(session_file)
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd('source ' .. session_file)
    end
  end

  local function session_save()
    local session_file = vim.fn.input('Session file: ', get_default_session_file(), 'file')
    if session_file and #session_file > 0 then
      vim.cmd('Obsession ' .. session_file)
    end
  end

  local function session_restore()
    local session_file = vim.fn.input('Session file: ', get_default_session_file(), 'file')
    load_session(session_file)
  end

  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { desc = desc, noremap = true, silent = true })
  end

  nmap('<leader>os', session_save, '[O]bsession [S]ave')
  nmap('<leader>or', session_restore, '[O]bsession [R]estore')
  nmap('<leader>op', '<cmd>Obsession<CR>', '[O]bsession [P]ause')
  nmap('<leader>ox', '<cmd>Obsession!<CR>', '[O]bsession Close and Delete[x]')
end

return M
