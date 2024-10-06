M = {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  opts = {
    enabled = true,
    message_template = ' <summary> • <date> • <author> • <<sha>>',
    date_format = '%r (%d-%b-%y %X)',
    delay = 5000,
    schedule_event = 'CursorHold',
    virtual_text_column = 40,
  },
}

return M
