set rtp^=~/env/vimplugin

set hlsearch incsearch
set sw=4 ts=4
set si ai autoread
set expandtab smarttab
colorscheme elflord
map <F12> :Dox<CR>
set splitbelow  " vertical split, open new split below (def up)
set splitright  " horizontal split, open new split on the right (def left)
set directory=~/env/swap

" ----------- For vimdiff------------------
" Ctrl-Up: Send the diff to other window
" Ctrl-Down: Get the diff from other window
map <ESC>[A :diffput<CR>
map <ESC>[B :diffget<CR>
" mapping for laptop keyboard
map <ESC>[1;5A :diffput<CR>
map <ESC>[1;5B :diffget<CR>

" Set colorscheme for vimdiff. The default one is an eye-sore.
highlight Normal term=none cterm=none ctermfg=White ctermbg=Black gui=none guifg=White guibg=Black
highlight DiffAdd cterm=none ctermfg=fg ctermbg=Blue gui=none guifg=fg guibg=Blue
highlight DiffDelete cterm=none ctermfg=fg ctermbg=Blue gui=none guifg=fg guibg=Blue
highlight DiffChange cterm=none ctermfg=fg ctermbg=Blue gui=none guifg=fg guibg=Blue
highlight DiffText cterm=none ctermfg=bg ctermbg=White gui=none guifg=bg guibg=White

" set noexpandtab for make files
autocmd FileType make setlocal noexpandtab

" Highlight unwanted spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Show 80 char column line
" autocmd FileType c,cpp set colorcolumn=120
" highlight ColorColumn ctermbg=7

" recreate tags file with F5
map <F5> :!ctags -R .<CR>:!cscope -Rb<CR>:cs reset<CR><CR>

" build using makeprg with <F7>
map <F9> :make! -s<CR>

" highlight matching braces
set showmatch

" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" Smartly detect ctags in parent directories
set tags=tags;

" https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
" Open QuickFix window if make results in error
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" CSCOPE setup
if has("cscope")
     set csto=0
     set cst
     set nocsverb
     " add any database in current directory
     if filereadable("cscope.out")
         cs add cscope.out
         " else add database pointed to by environment
     elseif $CSCOPE_DB != ""
         cs add $CSCOPE_DB
     endif
     set csverb
endif

" jump to a function declaration
nmap <silent> <C-\> :cs find s <C-R>=expand("<cword>")<CR><CR>
" show a list of where function is called
nmap <silent> <C-_> :cs find c <C-R>=expand("<cword>")<CR><CR>

" Set filetype for log files
au BufRead,BufNewFile *.log             setfiletype log

" Set runtime path for fzf
set rtp+=~/.fzf

" Ctrl-o to open file using fzf
map <C-o> :Files<CR>
map <F7> :Tags<CR>
map <C-_> :Rg <C-R><C-W><CR>

" Use fzf with ag to ignore files from .gitignore
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
" let $FZF_DEFAULT_COMMAND = '(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" statusline color
hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
hi StatusLineNC guibg=White ctermfg=8 guifg=DarkSlateGray ctermbg=15

" Configure F8 to use ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --no-heading --line-number --color=always '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

" command! -bang -nargs=* Rg
"        \ call fzf#vim#grep(
"        \       'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 0,
"        \       {'options': '--no-hscroll --delimiter : --nth 4..'},
"        \       <bang>0)
map <F8> :Rg<CR>

" Display statusline with current file name in it
set statusline+=%f
set statusline+=\ %{Tlist_Get_Tagname_By_Line()}
set statusline +=%=%-14.(%l,%c%V%)\ %P
set laststatus=2

map <F4> :TlistToggle<CR>
set pastetoggle=<F3>
