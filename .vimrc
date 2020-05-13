scriptencoding utf-8

set clipboard+=unnamedplus
set colorcolumn=81
set cursorline
set ignorecase
set list
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set mouse=a
set novisualbell
set number
set viminfo='1000,f1,:100,@100,/20,h
set whichwrap+=<,>,h,l,[,]

" Guard for plain vim
if !has('nvim')
filetype indent plugin on
syntax enable sync minlines=200
set background=dark
set hlsearch
set incsearch
set laststatus=2
set nocompatible
set ttyfast
"set formatoptions+=nr2l
"set lazyredraw
"set noshowmode
"set nowritebackup
"set showbreak=>\
"set showmatch
"set smartcase
"set spellfile=~/.vim/spell/.en.add
"set spelllang=en_au
"set synmaxcol=200
"set termguicolors
endif

if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let &undodir = expand('$HOME/.vim/undo')
    call system('mkdir -p ' . &undodir)
    set undofile
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
Plug 'iCyMind/NeoSolarized'
Plug 'godlygeek/tabular'
Plug 'w0rp/ale'
" Filetypes
Plug 'cespare/vim-toml'
Plug 'cmcaine/vim-uci'
Plug 'fatih/vim-go'
Plug 'ziglang/zig.vim'
Plug 'cstrahan/vim-capnp'
Plug 'jamessan/vim-gnupg'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
Plug 'lifepillar/pgsql.vim'
Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'
Plug 'pearofducks/ansible-vim'
Plug 'evanleck/vim-svelte'
Plug 'tmatilai/gitolite.vim'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'vim-scripts/ebnf.vim'
Plug 'ledger/vim-ledger'
Plug 'liuchengxu/graphviz.vim'
Plug 'ziglang/zig.vim'
" Utils
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
"Plug 'jreybert/vimagit'
Plug 'tpope/vim-commentary'
Plug 'jlanzarotta/bufexplorer'
call plug#end()

let g:neosolarized_contrast = "high"
let g:pymode_python = 'python3'
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_metalinter_enabled = ['revive', 'vet', 'golint', 'errcheck']
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0
let g:ansible_unindent_after_newline = 1
let g:ale_sign_column_always = 1
let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}
let g:ale_linters = {
			\ 'javascript': ['standard'],
			\ 'yaml': ['cfn-python-lint'],
			\ 'svelte': ['stylelint', 'eslint'],
			\ 'go': ['gopls']
			\ }
let g:ale_linters_explicit = 1
let g:ale_fixers = {
			\   'svelte': ['prettier', 'eslint'],
			\}

colorscheme NeoSolarized

if executable("rg")
    set grepprg=rg\ --smart-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let &undodir = expand('$HOME/.vim/undo')
    call system('mkdir -p ' . &undodir)
    set undofile
endif

"nnoremap ; :
" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber<CR>:set nofoldenable<CR>:set nolist<CR>:set paste<CR>
nnoremap <F3> :set number<CR>:set foldenable<CR>:set list<CR>:set nopaste<CR>
" Space clears highlighting
:noremap <silent> <Space> :nohlsearch<CR><Space>
" add files with wildcards, like **/*.md for all markdown files
nnoremap <leader>a :argadd <c-r>=fnameescape(expand('%:p:h'))<cr>/*<C-d>
" similar to buffers but for opening a single file
nnoremap <leader>e :e **/
" drops to the grep line
nnoremap <leader>g :grep<space>
" strips whitespace using a little function
nnoremap <leader>s :call StripTrailingWhitespace()<cr>
" switches to the last buffer edited
nnoremap <leader>q :b#<cr>
" Reflow paragraph with Q in normal and visual mode
nnoremap <leader>f gqap
vnoremap <leader>Q gq

" https://stackoverflow.com/a/2138303
let g:stop_autocomplete=0
function! CleverTab(type)
    if a:type=='omni'
        if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
            let g:stop_autocomplete=1
            return "\<TAB>"
        elseif !pumvisible() && !&omnifunc
            return "\<C-X>\<C-O>\<C-P>"
        endif
    elseif a:type=='keyword' && !pumvisible() && !g:stop_autocomplete
        return "\<C-X>\<C-N>\<C-P>"
    elseif a:type=='next'
        if g:stop_autocomplete
            let g:stop_autocomplete=0
        else
            return "\<C-N>"
        endif
    endif
    return ''
endfunction
inoremap <silent><TAB> <C-R>=CleverTab('omni')<CR><C-R>=CleverTab('keyword')<CR><C-R>=CleverTab('next')<CR>

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

function! ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction
nnoremap <silent> <C-c><C-y> :call ToggleConcealLevel()<CR>

autocmd BufRead,BufNewFile *mutt* setlocal ft=mail
autocmd Filetype mail setlocal nohlsearch spell nobackup noswapfile nowritebackup noautoindent
autocmd BufRead,BufNewFile Jenkinsfile setlocal ft=groovy
autocmd BufRead,BufNewFile *.tmpl setlocal ft=gohtmltmpl
autocmd Filetype javascript setlocal ts=2 sw=2 et nowrap
autocmd Filetype json setlocal ts=2 sw=2 et nowrap
autocmd Filetype html setlocal ts=2 sw=2 et
autocmd Filetype markdown setlocal spell
autocmd Filetype yaml setlocal ts=2 sw=2

autocmd FileType ledger setlocal ts=2 sw=2
autocmd FileType ledger noremap { ?^\d<CR>
autocmd FileType ledger noremap } /^\d<CR>
"autocmd FileType ledger inoremap <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
autocmd FileType ledger vnoremap <silent> <Tab> :LedgerAlign<CR>

" Jump to last known position
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \ exe "normal! g`\"" | endif
