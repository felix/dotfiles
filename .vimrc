filetype indent plugin on
scriptencoding utf-8
syntax enable sync minlines=200

set background=dark
set cinoptions=b1
set colorcolumn=81
set cursorline
set directory=~/tmp//,/tmp//,.
set encoding=utf-8
set expandtab
set formatoptions+=nr2l
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set list
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set mouse=a
set nocompatible
set noshowmode
set nowritebackup
set number
set shiftwidth=4
set showbreak=>\
set showmatch
set smartcase
set spelllang=en_au
set synmaxcol=200
set tabstop=4
set ttyfast
set viminfo='1000,f1,:100,@100,/20,h
set novisualbell
set whichwrap+=<,>,h,l,[,]

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    +-- current column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- modified flag in square brackets
"              +-- full path to file in the buffer

call plug#begin('~/.vim/plugged')
" UI
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'w0rp/ale'
" Filetypes
Plug 'cespare/vim-toml'
Plug 'cmcaine/vim-uci'
Plug 'fatih/vim-go'
Plug 'jamessan/vim-gnupg'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
Plug 'lifepillar/pgsql.vim'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'slim-template/vim-slim'
Plug 'tmatilai/gitolite.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'zah/nim.vim'
" Utils
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'romainl/vim-qf'
call plug#end()

let g:solarized_termtrans=1
let g:solarized_visibility='low'
let g:solarized_bold=0
let g:solarized_underline=0
"let g:solarized_italic=1
"let g:solarized_termcolors=256
let g:vim_markdown_frontmatter=1
let g:ale_sign_column_always = 1
let g:ale_linters = { 'javascript': ['standard'] }
let g:go_fmt_fail_silently = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:GPGExecutable = 'gpg2 --trust-model always'
colorscheme solarized
hi SpellBad ctermfg=white

" learn those keys!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
"nnoremap ; :
" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber<CR>:set nofoldenable<CR>:set nolist<CR>:set paste<CR>
nnoremap <F3> :set number<CR>:set foldenable<CR>:set list<CR>:set nopaste<CR>
" Space clears highlighting
:noremap <silent> <Space> :nohlsearch<CR><Space>
" add files with wildcards, like **/*.md for all markdown files
nnoremap <leader>a :argadd <c-r>=fnameescape(expand('%:p:h'))<cr>/*<C-d>
" buffer prompt and displays all buffers
nnoremap <leader>b :b <C-d>
" similar to buffers but for opening a single file
nnoremap <leader>e :e **/
" drops to the grep line
nnoremap <leader>g :grep<space>
" uses the Ilist function from qlist -- makes :ilist go into a quickfix window
nnoremap <leader>i :Ilist<space>
" lands me on a taglist jump command line
nnoremap <leader>j :tjump /
" runs make
nnoremap <leader>m :make<cr>
" strips whitespace using a little function
nnoremap <leader>s :call StripTrailingWhitespace()<cr>
" switches to the last buffer edited
nnoremap <leader>q :b#<cr>
" runs :TTags but on the current file, lands on a prompt to filter the tags
nnoremap <leader>t :TTags<space>*<space>*<space>.<cr>
" Reflow paragraph with Q in normal and visual mode
nnoremap <leader>f gqap
vnoremap <leader>Q gq

" replace supertab?? see http://vimdoc.sourceforge.net/htmldoc/insert.html#ins-completion
" file names
inoremap <silent> ;f <C-x><C-f>
" current file
inoremap <silent> ;n <C-x><C-n>
" keywords in current and included
inoremap <silent> ;i <C-x><C-i>
" whole lines
inoremap <silent> ;l <C-x><C-l>
" omni
inoremap <silent> ;o <C-x><C-o>
" thesaurus
inoremap <silent> ;t <C-x><C-]>
" user
inoremap <silent> ;u <C-x><C-u>

nnoremap <silent> <C-c><C-y> :call ToggleConcealLevel()<CR>
map <leader>w :call <SID>ToggleVisibility()<CR>


" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Strip all trailing whitespace in file
function! StripTrailingWhitespace()
    "exec ':%s/[ \t]\+$//gc'
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction

" Show whitespace
function! s:ToggleVisibility()
    if g:solarized_visibility != 'high'
        let g:solarized_visibility = 'high'
    else
        let g:solarized_visibility = 'low'
    endif
    color solarized
endfunction

function! ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction

autocmd BufRead,BufNewFile *.tag setlocal ft=html
autocmd BufRead,BufNewFile *mutt* setlocal ft=mail
autocmd BufRead,BufNewFile *.deface setlocal ft=html
autocmd BufRead,BufNewFile *.pug setlocal ft=slim
autocmd BufRead,BufNewFile Jenkinsfile setlocal ft=groovy
autocmd Filetype javascript setlocal ts=2 sw=2 nowrap
autocmd Filetype html setlocal ts=2 sw=2
autocmd Filetype mail setlocal nohlsearch spell nobackup noswapfile nowritebackup noautoindent
autocmd Filetype markdown setlocal spell
autocmd Filetype ruby setlocal ts=2 sw=2

" Jump to last known position
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \ exe "normal! g`\"" | endif
