scriptencoding utf-8
set encoding=utf-8
set nocompatible
filetype indent plugin on
syntax enable sync minlines=200
"set listchars=tab:•\ ,trail:~,extends:>,precedes:<,nbsp:␣
set cinoptions=b1
set colorcolumn=80
set cursorline
set directory=~/tmp//,/tmp//,.
set expandtab
set formatoptions+=nr2l
set hlsearch
set ignorecase
set list
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set mouse=a
set nowritebackup
set number
set shiftwidth=4
set showbreak=>\
set showmatch
set smartcase
set spelllang=en
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set synmaxcol=200
set tabstop=4
set viminfo='1000,f1,:100,@100,/20,h
set visualbell
set whichwrap+=<,>,h,l,[,]


"
" Plugins
"

call plug#begin('~/.vim/plugged')
Plug 'jlanzarotta/bufexplorer'
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'ervandew/supertab'
Plug 'scrooloose/syntastic'
Plug 'jamessan/vim-gnupg'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'pearofducks/ansible-vim'
Plug 'tmatilai/gitolite.vim'
Plug 'leafgarland/typescript-vim'
Plug 'cmcaine/vim-uci'
Plug 'lervag/vimtex'
Plug 'slim-template/vim-slim'
call plug#end()


"
" Plugin config
"

set background=dark
let g:solarized_termtrans=1
let g:solarized_visibility='low'
colorscheme solarized
let g:vim_markdown_frontmatter=1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_ignore_files = ['\msrc/vendor','\mnode_modules','\masn1.js']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['standard']

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" Force tsc to find tsconfig.json
let g:syntastic_typescript_tsc_fname = ''

let g:GPGExecutable = 'gpg2 --trust-model always'


"
" Functions
"

" learn those keys!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber<CR>:set nofoldenable<CR>:set nolist<CR>:set paste<CR>
nnoremap <F3> :set number<CR>:set foldenable<CR>:set list<CR>:set nopaste<CR>
" Space clears highlighting
:noremap <silent> <Space> :nohlsearch<CR><Space>
" Reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Strip all trailing whitespace in file
function! StripWhitespace ()
    exec ':%s/[ \t]\+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

" Jump to last known position
au BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \ exe "normal! g`\"" | endif

" Show whitespace
function! s:ToggleVisibility()
    if g:solarized_visibility != 'high'
        let g:solarized_visibility = 'high'
    else
        let g:solarized_visibility = 'low'
    endif
    color solarized
endfunction
map <leader>w :call <SID>ToggleVisibility()<CR>

autocmd Filetype javascript setlocal ts=2 sw=2 nowrap
autocmd Filetype html setlocal ts=2 sw=2
autocmd BufRead,BufNewFile package.json setlocal ts=2 sw=2
autocmd BufRead,BufNewFile *.tag setlocal ft=html
autocmd Filetype mail setlocal nohlsearch spell spelllang=en_au
autocmd Filetype markdown setlocal spell spelllang=en_au
autocmd Filetype ruby setlocal ts=2 sw=2
autocmd BufRead,BufNewFile *.deface setlocal ft=html
autocmd BufRead,BufNewFile *.pug setlocal ft=slim
