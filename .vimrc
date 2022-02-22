scriptencoding utf-8

set colorcolumn=81
set cursorline
set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
"set foldminlines=10
set foldnestmax=2
set list
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set mouse=a
set novisualbell
set number
set re=0
set smartcase
set spelllang=en_au
set viminfo='1000,f1,:100,@100,/20,h
set whichwrap+=<,>,h,l,[,]

if (has("termguicolors"))
  set termguicolors
endif
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed
else
  set clipboard=unnamedplus
endif

" Guard for plain vim
if !has('nvim')
  filetype indent plugin on
  syntax enable sync minlines=20
  set background=dark
  set hlsearch
  set incsearch
  set laststatus=2
  set nocompatible
  set ttyfast
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

set statusline=%F%m%r%h%w[%{&ff}]%y[%p%%][%l/%L,%v]

call plug#begin('~/.vim/plugged')
" UI
Plug 'iCyMind/NeoSolarized'
Plug 'godlygeek/tabular'
"Plug 'w0rp/ale'
" Filetypes
Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'cmcaine/vim-uci'
Plug 'cstrahan/vim-capnp'
Plug 'evanleck/vim-svelte'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'jamessan/vim-gnupg'
Plug 'ledger/vim-ledger'
Plug 'lervag/vimtex'
Plug 'lifepillar/pgsql.vim'
Plug 'liuchengxu/graphviz.vim'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'tmatilai/gitolite.vim'
Plug 'vim-scripts/ebnf.vim'
Plug 'ziglang/zig.vim'
" Utils
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'jlanzarotta/bufexplorer'

Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'hrsh7th/nvim-compe'
" Plug 'steelsojka/completion-buffers'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Plugin configs

let g:neosolarized_contrast="high"
let g:pymode_python='python3'
" Go
let g:go_list_type='quickfix'
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command='gopls'
let g:go_rename_command='gopls'
let g:go_auto_type_info = 1
"let g:go_metalinter_command='golangci-lint'
"let g:go_metalinter_enabled = ['revive', 'vet', 'golint', 'errcheck', 'staticcheck']
let g:go_metalinter_autosave_enabled=[]
" Javascript
let g:svelte_indent_script=0
let g:svelte_indent_style=0
" Other
let g:tex_flavor='latex'
let g:ledger_date_format='%Y-%m-%d'
let g:ansible_unindent_after_newline=1

let g:ale_sign_column_always=1
let g:ale_linter_aliases={'svelte': ['css', 'javascript']}
let g:ale_linters={
      \ 'javascript': ['standard'],
      \ 'yaml': ['cfn-python-lint'],
      \ 'svelte': ['stylelint', 'eslint'],
      \ 'sh': ['shellcheck'],
      \ }
      " \ 'go': ['gopls'],
" 'go': ['gofmt', 'golint', 'go vet', 'gopls'],
let g:ale_linters_explicit=1
let g:ale_fixers={
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
" " GoDef
" nnoremap <F4> :GoDef<CR>
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

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Avoid showing message extra message when using completion
set shortmess+=c

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
autocmd BufRead,BufNewFile *.m4 setlocal ft=m4
autocmd FileType ledger setlocal ts=4 sw=4 et
autocmd FileType ledger noremap { ?^\d<CR>
autocmd FileType ledger noremap } /^\d<CR>
autocmd FileType ledger inoremap <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
autocmd FileType ledger vnoremap <silent> <Tab> :LedgerAlign<CR>
autocmd FileType php setlocal ts=4 sw=4 et

" Jump to last known position
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \ exe "normal! g`\"" | endif
