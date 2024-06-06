M = {
  'saecki/crates.nvim',
  tag = 'stable',
  event = { 'BufRead Cargo.toml' },
}

function M.config(_, opts)
  local keymap = vim.keymap
  local bufnr = vim.api.nvim_get_current_buf()

  local crates = require('crates')
  crates.setup(opts)

  local function buf_map_opts(desc)
    return { desc = '[r]ust [c]rates: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  keymap.set('n', '<leader>rct', crates.toggle, buf_map_opts('[t]oggle'))
  keymap.set('n', '<leader>rcr', crates.reload, buf_map_opts('[r]eload'))

  keymap.set('n', '<leader>rcv', crates.show_versions_popup, buf_map_opts('select spec [v]ersions'))
  keymap.set('n', '<leader>rcf', crates.show_features_popup, buf_map_opts('select spec [f]eatures'))
  keymap.set('n', '<leader>rcd', crates.show_dependencies_popup, buf_map_opts('show project [d]ependencies'))

  keymap.set('n', '<leader>rcu', crates.update_crate, buf_map_opts('[u]pdate current'))
  keymap.set('v', '<leader>rcu', crates.update_crates, buf_map_opts('[u]pdate selected'))
  keymap.set('n', '<leader>rca', crates.update_all_crates, buf_map_opts('update [a]ll'))
  keymap.set('n', '<leader>rcU', crates.upgrade_crate, buf_map_opts('[U]pgrade current'))
  keymap.set('v', '<leader>rcU', crates.upgrade_crates, buf_map_opts('[U]pgrade selected'))
  keymap.set('n', '<leader>rcA', crates.upgrade_all_crates, buf_map_opts('upgrade [A]ll'))

  keymap.set('n', '<leader>rcx', crates.expand_plain_crate_to_inline_table,
    buf_map_opts('expand_plain_crate_to_inline_table'))
  keymap.set('n', '<leader>rcX', crates.extract_crate_into_table, buf_map_opts('extract_crate_into_table'))

  keymap.set('n', '<leader>rcH', crates.open_homepage, buf_map_opts('open [H]omepage'))
  keymap.set('n', '<leader>rcR', crates.open_repository, buf_map_opts('open [R]epository'))
  keymap.set('n', '<leader>rcD', crates.open_documentation, buf_map_opts('open [D]ocumentation'))
  keymap.set('n', '<leader>rcC', crates.open_crates_io, buf_map_opts('browse [C]rates.io'))
end

return M
