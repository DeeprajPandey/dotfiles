M = {
	"lervag/vimtex",
	-- tag = "v2.15", -- uncomment to pin to a specific release
	-- ft = { 'latex', 'tex', 'plaintex', 'context', 'bib' },
	init = function()
		-- ╭─────────────────────────────╮
		-- │ lervag/vimtex configuration │
		-- ╰─────────────────────────────╯

		-- load custom compiler plugin: nvim/plugin/tex.vim
		vim.cmd("compiler tex")

		-- Experimental
		-- ────────────
		vim.g.vimtex_format_enabled = true
		vim.g.vimtex_fold_enabled = true
		-- No QuickFix menu for compiler warnings
		vim.g.vimtex_quickfix_open_on_warning = false

		-- Enable inverse search using okular
		vim.g.vimtex_view_general_viewer = "skim"
		vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]

		-- VimTeX uses latexmk as the default compiler backend. If you use it, which is
		-- strongly recommended, you probably don"t need to configure anything. If you
		-- want another compiler backend, you can change it as follows. The list of
		-- supported backends and further explanation is provided in the documentation,
		-- see ":help vimtex-compiler".
		vim.g.vimtex_compiler_method = "latexmk"

		-- :h vimtex-compiler-latexmk auch hilfreich
		-- Einige Einstellungen finden sich auch in ~/LaTeX/.latexmkrc
		-- Führe $compiling_cmd für latexmk (steht in ~/LaTeX/.latexmkrc) aus
		vim.g.vimtex_compiler_latexmk = { callback = 1 }

		-- Concealing
		-- ──────────
		-- Collides with TreeSitter, currently I prefer the latter
		vim.o.conceallevel = 2
		-- only works with <conceallevel = 2>
		vim.g.vimtex_syntax_conceal = {
			accents = 0, -- accents on letters, \^a -> â
			ligatures = 0, -- \aa --> å and '' --> “
			cites = 2,
			fancy = 0, -- \item --> ○, \\ --> <CR> arrow and more TODO: What exactly
			spacing = 0, -- conceal spacing commands like \quad, \bigskip, \[hv]space
			greek = 2,
			math_bounds = 2, -- $, $$, \(, \[ concealment
			math_delimiters = 2, -- Replace possibly modified math delimiters with a single unicode letter. Modified means delimiters prepended with e.g. `\left` or `\bigl`. As an example, this will perform the replacement: `\Biggl\langle ... \Biggr\rangle` --> `〈 ... 〉`
			math_fracs = 2, -- conceal simpre fractions
			math_super_sub = 0, -- super- and subscripts
			math_symbols = 2, -- math unicode concealment, \sum --> Σ
			sections = 2, -- markdown sections notation
			styles = 0, -- \emph, \textit, \textbf are concealed canonically
		}

		-- Spellchecking
		-- ─────────────
		-- Activate spellchecking
		-- Correct misspelled words with the first proposed word.
		vim.opt.spell = true
		vim.opt.spelllang = { "en_gb" }
		-- I had to download the German spell files to make spell checking work (for German)
		vim.opt.spellfile = {
			vim.fn.expand("~") .. "/.config/nvim/spell/en.utf-8.add",
		}
		-- vim.opt.spelloptions = { "camel" } -- Spellchecking on CamelCase words

		-- Keymaps
		-- ───────
		-- Compile .tex files to pdf using async `Make`
		-- (deps: vim-dispatch, nvim/plugin/tex.vim)
		vim.keymap.set("n", "<Leader>m", "<CMD>Make<CR>", { desc = "[M]ake" })
		-- Correct misspelled words with the first proposed word.
		vim.api.nvim_set_keymap("i", "<C-l>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { noremap = true })

		-- ─── Text object mappings ──────────
		-- Use `_sm` not `_s$` to delete/change/toggle surrounding math
		vim.keymap.set("n", "dsm", "<Plug>(vimtex-env-delete-math)", { desc = "Delete surrounding math" })
		vim.keymap.set("n", "csm", "<Plug>(vimtex-env-change-math)", { desc = "Change surrounding math" })
		vim.keymap.set("n", "tsm", "<Plug>(vimtex-env-toggle-math)", { desc = "Toggle surrounding math" })

		-- Use `ai` and `ii` for the item text object (s. below)
		vim.keymap.set({ "o", "x" }, "ai", "<Plug>(vimtex-am)", { desc = "\\item a-text object" })
		vim.keymap.set({ "o", "x" }, "ii", "<Plug>(vimtex-im)", { desc = "\\item i-text object" })

		-- Now, use `am` and `im` for the inline math text object
		--  default: `am`/`ii` aimed for the item text object but this object was remapped beofre to reuse `am`/`im`
		vim.keymap.set({ "o", "x" }, "am", "<Plug>(vimtex-a$)", { desc = "inline math a-text object" })
		vim.keymap.set({ "o", "x" }, "im", "<Plug>(vimtex-i$)", { desc = "inline math i-text object" })

		-- Vielleicht irgendwann interessant:
		-- search telescope symbols
		-- vim.keymap.set('n', '<leader>sl', function()
		--     require('telescope.builtin').symbols({ -- https://github.com/nvim-telescope/telescope-symbols.nvim
		--         sources = { 'latex' }
		--     })
		-- end, { desc = '[s]earch [l]atex symbols' })

		-- Autocommands
		-- ────────────
		local autocmd = vim.api.nvim_create_autocmd
		local latexGroup = vim.api.nvim_create_augroup("LaTeX-Autocmds", { clear = true })

		-- -- Load tex specific options for .bib files
		-- autocmd('FileType', {
		--   group = latexGroup,
		--   pattern = '*.bib',
		--   command = 'source ftplugin/tex_vimtex.lua',
		--   desc = 'Enable spell check for .bib-files.',
		-- })

		-- Open VimTeX-ToC of latex files.
		--  VimTeX has a keymapping for toggling: <LocalLeader>lt
		-- autocmd("VimEnter", {
		--     group = latexGroup,
		--     pattern = "*.tex",
		--     callback = function()
		--         vim.cmd("VimtexTocOpen")
		--         vim.cmd("vertical resize 30") -- resize ToC buffer
		--         vim.cmd("wincmd l")           -- move cursor to document window
		--     end,
		--     desc = "Open ToC of LaTeX files."
		-- })

		-- Center current line after selecting entry of the ToC.
		autocmd("User", {
			group = latexGroup,
			pattern = "VimtexEventTocActivated",
			command = "normal zz",
			desc = "Center current line.",
		})

		-- Center view after inverse searching
		autocmd("User", {
			group = latexGroup,
			pattern = "VimtexEventViewReverse",
			command = "normal! zMzvzz",
			desc = "Center view after InverseSearch.",
		})

		-- Refocus Neovim after Vimtex's forward search (:VimtexView) or Compilation, i. e. always after the produced document was focused.
		local function TexFocusVim()
			-- Filter output of `wmctrl -l` for current tex file name and grep it's window ID to refocus Neovim
			-- by extracting the first field in `wmctrl -l` table
			local current_file_name = vim.fn.expand("%")
			-- Extract file name by removing everything before last /.
			-- This guarantees that refocusing also works when the file is opened from another directory,
			-- f. i. when you have ~/a/b/lorem.tex and open lorem.tex from within ~/a.
			-- In theses caes vim.fn.expand('%') results in b/lorem.tex, which is not in wmctrl -l.
			current_file_name = current_file_name:gsub(".*/", "")
			local active_window_id = vim.fn.system("wmctrl -l | grep " .. current_file_name .. '| cut -d " " -f 1')

			-- Give window manager time to recognize focus moved to PDF viewer;
			-- tweak the 200m as needed for your hardware and window manager.
			os.execute("sleep " .. 0.2) -- sleep 200m

			-- Refocus Vim and redraw the screen
			-- TODO: add `silent` option <01-04-2023>
			vim.fn.execute("!wmctrl -ia " .. active_window_id) -- silent execute "!xdotool windowfocus " . expand(g:vim_window_id)

			-- TODO: add `!` <01-04-2023>
			vim.cmd.redraw() -- redraw!
		end

		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("vimtex_event_focus", { clear = true }),
			pattern = { "VimtexEventView", "VimtexEventCompileSuccess", "VimtexEventCompileFailed" },
			callback = TexFocusVim,
			desc = "Refocus Neovim after forward search and compilation",
		})
		--
		--
		--
		--
		--
		--
		-- -- config_vimtex.lua
		-- vim.g.vimtex_syntax_enabled = 1 -- Ensure syntax features are enabled
		-- vim.g.vimtex_imaps_enabled = 0
	end,
}

return M
