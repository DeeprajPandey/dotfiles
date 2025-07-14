" - https://github.com/changemewtf/no_plugins

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                    " line numbers
set relativenumber            " relative line numbers
set ruler                     " always show cursor coordinates
set showcmd                   " show partial commands in bottom right
" set nohlsearch                " disable search result highlights

""" show invisible chars
" set list

" highlight line with cursor
"set cursorline
":highlight CursorLine ctermbg=grey


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => No-Plugin Features
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" FINDING FILES:
" - hit tab to :find by partial match
" - use * to make it fuzzy
" - :b lets you autocomplete any open buffer

" Search down into subfolers
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" TAG JUMPING:
" - ^] to jump to tag under cursor
" - g^] for ambiguous tags
" - ^t to jump back up the tag stack

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" AUTOCOMPLETE: (:help ins-completion)
" - ^x^n for just this file
" - ^x^f for  filenames (works w/ path option)
" - ^x^] for nane
" - ^n for anything specified by the 'complete' option
" - ^n and ^p to go back forth in the suggestion list

" FILE BROWSING: (:help browse-maps)
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab

let g:netrw_banner=0          " disable banner
let g:netrw_browse_split=4    " open in prior window
let g:netrw_altv=1            " open splits to the right
let g:netrw_liststyle=3       " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'


" SNIPPETS:

"" Read an empty HTML template and move cursor to title
" nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a

" Function to insert skeletons from ~/.vim/skeletons/
function! InsertSkeleton(name)
  " execute ':-1read' expand('~/.vim/skeletons/' . a:name)
  execute '0r ~/.vim/skeletons/' . a:name
endfunction

" Filetype-specific defaults
autocmd FileType html       nnoremap <buffer> <leader>s :call InsertSkeleton('html')<CR>:call JumpToCursorMarker()<CR>
autocmd FileType css        nnoremap <buffer> <leader>s :call InsertSkeleton('css')<CR>
autocmd FileType python     nnoremap <buffer> <leader>s :call InsertSkeleton('python')<CR>jjA
autocmd FileType typescript nnoremap <buffer> <leader>s :call InsertSkeleton('typescript')<CR>jjA
autocmd FileType go         nnoremap <buffer> <leader>s :call InsertSkeleton('go')<CR>jjA
autocmd FileType cpp        nnoremap <buffer> <leader>s :call InsertSkeleton('cpp')<CR>jjA

" Auto-insert on new file
autocmd BufNewFile *.html 0r ~/.vim/skeletons/html
autocmd BufNewFile *.py   0r ~/.vim/skeletons/py
autocmd BufNewFile *.md   0r ~/.vim/skeletons/md

function! InsertMarkdownTemplate()
  let templates = split(globpath('~/.vim/skeletons/markdown', '*.md'), "\n")
  let choices = map(templates, {i, v -> fnamemodify(v, ':t:r')})
  let choice = inputlist(['Select a markdown template:'] + choices)
  if choice > 0
    execute '0r ~/.vim/skeletons/markdown/' . choices[choice - 1] . '.md'
  endif
endfunction

autocmd FileType markdown nnoremap <buffer> <leader>s :call InsertMarkdownTemplate()<CR>

function! JumpToCursorMarker()
  execute '/{{ cursor }}/'
  normal! "_ciw
endfunction

