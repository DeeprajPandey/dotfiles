-- select, move and swap by syntax node instead of by text pattern
local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main", -- master only works with nvim-treesitter master
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    -- these ftplugins map ]m/[m to regex jumps that would shadow ours
    vim.g.no_python_maps = true
    vim.g.no_ruby_maps = true
  end,
  opts = {
    select = { lookahead = true }, -- jump forward when the cursor isn't inside a match
    move = { set_jumps = true }, -- <C-o> returns to where a move started
  },
}

function M.config(_, opts)
  require("nvim-treesitter-textobjects").setup(opts)

  local select = require("nvim-treesitter-textobjects.select").select_textobject
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")
  local keymap = vim.keymap

  -- [a]round / [i]nside: [f]unction, [c]lass, [a]rgument
  for key, node in pairs({ f = "function", c = "class", a = "parameter" }) do
    keymap.set({ "x", "o" }, "a" .. key, function()
      select("@" .. node .. ".outer", "textobjects")
    end, { desc = "Around " .. node })
    keymap.set({ "x", "o" }, "i" .. key, function()
      select("@" .. node .. ".inner", "textobjects")
    end, { desc = "Inside " .. node })
  end

  keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer", "textobjects")
  end, { desc = "Next function start" })
  keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end, { desc = "Previous function start" })
  keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_end("@function.outer", "textobjects")
  end, { desc = "Next function end" })
  keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end, { desc = "Previous function end" })

  keymap.set("n", "<leader>a", function()
    swap.swap_next("@parameter.inner")
  end, { desc = "Swap with next [a]rgument" })
  keymap.set("n", "<leader>A", function()
    swap.swap_previous("@parameter.inner")
  end, { desc = "Swap with previous [A]rgument" })
end

return M
