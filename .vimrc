scriptencoding utf-8
set encoding=utf-8
set nocompatible
filetype indent plugin on
syntax enable sync minlines=200
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
set synmaxcol=200
set tabstop=4
set viminfo='1000,f1,:100,@100,/20,h
set visualbell
set whichwrap+=<,>,h,l,[,]
set ttyfast
set lazyredraw
set background=dark
set noshowmode
set laststatus=2

"set statusline=
"set statusline+=%<\                           " cut at start
"set statusline+=[%n%H%M%R%W]\                 " flags and buf no
"set statusline+=%f\                           " path
"set statusline+=%1*%{ShowFileFormatFlag(&fileformat)}%*
"set statusline+=%y\                           " file type
"set statusline+=%=                            " right align
"set statusline+=%{strlen(&fenc)?&fenc:&enc}\  " encoding
"set statusline+=%b:%B\  " encoding
"set statusline+=%10((%l,%c)%)\                " line and column
"set statusline+=%P                            " percentage of file

"
" Plugins
"

call plug#begin('~/.vim/plugged')
Plug 'jlanzarotta/bufexplorer'
Plug 'altercation/vim-colors-solarized'
Plug 'godlygeek/tabular'
Plug 'ervandew/supertab'
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale'
Plug 'jamessan/vim-gnupg'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'tmatilai/gitolite.vim'
Plug 'leafgarland/typescript-vim'
Plug 'cmcaine/vim-uci'
Plug 'lervag/vimtex'
Plug 'slim-template/vim-slim'
call plug#end()

" Auto-install plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

"
" Plugin config
"

let g:solarized_termtrans=1
let g:solarized_visibility='low'
let g:solarized_bold=0
let g:solarized_underline=0
"let g:solarized_italic=1
"let g:solarized_termcolors=256
let g:lightline = { 'colorscheme': '16color', }
let g:vim_markdown_frontmatter=1
let g:ale_sign_column_always = 1
let g:ale_linters = { 'javascript': ['standard'], }
let g:ale_javascript_standard_executable = 'semistandard'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:GPGExecutable = 'gpg2 --trust-model always'
colorscheme solarized


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
