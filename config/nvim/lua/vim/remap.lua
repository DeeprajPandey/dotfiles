-- Set space as the global leader key
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", "<cmd>Lexplore<CR>", {noremap = true, silent = true, desc = "Open project drawer"})


-- Normal Mode Mappings
-- keep cursor at current location when appending lines
vim.keymap.set("n", "J", "mzJ`z", {noremap = true, desc = "Join lines without changing cursor position"})

-- ctrl+d,u scrolls half-page down, up w/ centered cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, desc = "Scroll half-page down and center cursor"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, desc = "Scroll half-page up and center cursor"})

-- keep search results to the middle of the screen
vim.keymap.set("n", "n", "nzzzv", {noremap = true, desc = "Jump to next search result, center screen, and reselect"})
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, desc = "Jump to previous search result, center screen, and reselect"})

-- alt paste where delete during paste is mapped to void register to preserve yanked text
vim.keymap.set("x", "<leader>p", [["_dP]], {noremap = true, desc = "Paste in visual mode without overwriting the yank register"})

-- alt yank mapped to + register (sys clipboard)
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], {noremap = true, desc = "Yank to system clipboard"})
vim.keymap.set("n", "<leader>Y", [["+Y]], {noremap = true, desc = "Yank entire line to system clipboard"})

-- alt delete to void register in normal and visual modes
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], {noremap = true, desc = "Delete without affecting the yank register"})

-- paste in vertical visual mode works only if Esc is used to exit mode
vim.keymap.set("i", "<C-c>", "<Esc>", {noremap = true, desc = "Map Ctrl+C to Escape in insert mode"})

vim.keymap.set("n", "Q", "<nop>", {noremap = true, desc = "Disable Ex mode mapping to Q"})

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {noremap = true, silent = true, desc = "Go to next item in quickfix list and center on screen"})
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {noremap = true, silent = true, desc = "Go to previous item in quickfix list and center on screen"})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {noremap = true, silent = true, desc = "Go to next item in location list and center on screen"})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {noremap = true, silent = true, desc = "Go to previous item in location list and center on screen"})

-- Close buffer without closing the window
vim.keymap.set("n", "<leader>bd", "<cmd>bp|bd #<CR>", {noremap = true, silent = true, desc = "Close buffer without closing the window"})

-- substitute current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {noremap = true, desc = "Substitute the current word globally with prompt for replacement"})

-- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {noremap = true, silent = true, desc = "Make current file executable"})

-- press leader twice to source current file
vim.keymap.set("n", "<leader><leader>", function()
vim.cmd("so %")
end, {desc = "Source the current file"})

-- Misc Configurations
-- quicker window movement (drop the C-w)
vim.keymap.set("n", "<C-j>", "<C-w>j", {noremap = true, desc = "Move cursor to the window below"})
vim.keymap.set("n", "<C-k>", "<C-w>k", {noremap = true, desc = "Move cursor to the window above"})
vim.keymap.set("n", "<C-h>", "<C-w>h", {noremap = true, desc = "Move cursor to the left window"})
vim.keymap.set("n", "<C-l>", "<C-w>l", {noremap = true, desc = "Move cursor to the right window"})

-- toggle relative numbering
vim.keymap.set("n", "<C-n>", ":set rnu!<CR>", {noremap = true, silent = true, desc = "Toggle relative numbering"})
