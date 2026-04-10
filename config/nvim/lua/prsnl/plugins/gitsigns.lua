local M = {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
      end

      -- navigation
      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Prev hunk")

      -- blame
      map("n", "<leader>gb", gs.blame_line, "Blame line")
      map("n", "<leader>gB", function()
        gs.blame_line({ full = true })
      end, "Blame full commit")
      map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle inline blame")

      -- hunk actions
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>ga", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
      map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

      -- buffer actions
      map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
      map("n", "<leader>gd", gs.diffthis, "Diff this")
    end,
  },
}

return M
