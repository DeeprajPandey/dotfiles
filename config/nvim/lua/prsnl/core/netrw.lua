-- for concise reference to vim global table
local g = vim.g

g.netrw_winsize = 30                    -- set window size to 30%
g.netrw_banner = 1                      -- keep the top banner enabled

g.netrw_sizestyle = "H"                 -- human readable file sizes

g.netrw_sort_sequence = [[[\/]$,*]]     -- sort dirs first

-- change copy command to enable recursive dir copies
g.netrw_localcopydircmd = 'cp -r'       -- recursive copy for dirs
g.netrw_localmkdir = 'mkdir -p'         -- recursive create for dirs

-- Netrw list style
-- 0 : thin listing (one file per line)
-- 1 : long listing (one file per line with timestamp information and file size)
-- 2 : wide listing (multiple files in columns)
-- 3 : tree style listing
vim.g.netrw_liststyle = 0

-- Open files in split
-- 0 : re-use the same window (default)
-- 1 : horizontally splitting the window first
-- 2 : vertically   splitting the window first
-- 3 : open file in new tab
-- 4 : act like "P" (ie. open previous window)
vim.g.netrw_browse_split = 0

-- show all files (1: not hidden only, 2: hidden only)
g.netrw_hide = 0

vim.cmd("hi! link netrwMarkFile Search")

-- -- hide files: from .gitignore
-- g.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()
