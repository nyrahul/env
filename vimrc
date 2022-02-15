" use vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mzlogin/vim-markdown-toc'
call vundle#end()
filetype plugin indent on

set rtp^=~/env/vimplugin
set wildmenu
set hlsearch incsearch
set sw=4 ts=4 nu
set si ai autoread
set smarttab
set encoding=utf-8
" set expandtab " go code does not like expandtab
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
map <F5> :!ctags --exclude=.git -R .<CR>:!cscope -Rb<CR>:cs reset<CR><CR>

map <F9> :make!<CR>
map <C-F9> :make! clean all<CR>

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
map <C-k> :Files<CR>
map <F7> :Tags<CR>

" KEY: Ctrl-/ to riggrep including _test.go files
map <C-_> :Rg <C-R><C-W><CR>

" KEY: Alt-/ or Ctrl-Alt-/ to riggrep without searching in _test.go files
if has('nvim')
else
execute "set <M-/>=\e/"
endif
nnoremap <M-/> /
map <M-/> :RgSkipGlobs <C-R><C-W><CR>

" KEY: Alt-, or Ctrl-Alt-, to search for the word under cursor in current file
" with preview
" execute "set <M-,>=\e,"
nnoremap <M-,> ,
map <M-,> :BLines <C-R><C-W><CR>

" Use fzf with ag to ignore files from .gitignore
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
" let $FZF_DEFAULT_COMMAND = '(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'

" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" statusline color
" hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
" hi StatusLineNC guibg=White ctermfg=8 guifg=DarkSlateGray ctermbg=15

" Configure F6 to use ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg -w --column --no-heading --line-number --color=always --iglob !cscope.out --iglob !tags '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

command! -bang -nargs=* RgSkipGlobs
  \ call fzf#vim#grep('rg -w --column --no-heading --line-number --color=always --iglob !cscope.out --iglob !tags --iglob "!*_test.go" '.shellescape(<q-args>),
  \ 1,
  \ fzf#vim#with_preview(),
  \ <bang>0)

command! -bang -nargs=* BLines
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --smart-case . '.fnameescape(expand('%:p')), 1,
    \   fzf#vim#with_preview({'options': '--layout reverse --query '.shellescape(<q-args>).' --with-nth=4.. --delimiter=":"'}, 'right:50%'))
    " \   fzf#vim#with_preview({'options': '--layout reverse  --with-nth=-1.. --delimiter="/"'}, 'right:50%'))

" command! -bang -nargs=* Rg
"        \ call fzf#vim#grep(
"        \       'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 0,
"        \       {'options': '--no-hscroll --delimiter : --nth 4..'},
"        \       <bang>0)
map <F6> :Rg<CR>

" Display statusline with current file name in it
set statusline+=%f
set statusline+=\ %{Tlist_Get_Tagname_By_Line()}
set statusline +=%=%-14.(%l,%c%V%)\ %P
set laststatus=2

map <F4> :TlistToggle<CR>
set pastetoggle=<F3>

let g:fzf_tags_command='ctags --exclude=.git -links=no -R'

execute pathogen#infect()

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/env/ycm_extra_conf.py'

set completeopt-=preview

" Project specific vim settings
set exrc
set secure

" Enable spell-check for certain filetypes and set the dictionary file
augroup ignoreSpell
    autocmd!
"    autocmd BufRead,BufNewFile *.txt setlocal spell
augroup END
set spellfile=~/env/spell/en.utf-8.add

if !has('gui_running')
    set t_Co=256
endif
set noshowmode
let g:lightline = {
            \ 'colorscheme': 'PaperColor',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ }

colorscheme elflord
nmap <F1> <nop>
map <F1> <Esc>
imap <F1> <Esc>

" Open read-only files with different colorscheme
function CheckRo()
    if &readonly
        colorscheme industry
	else
        colorscheme elflord
    endif
endfunction
au BufReadPost * call CheckRo()
