
call plug#begin('~/.vim/plugged')
" UI
Plug 'lifepillar/vim-solarized8'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'w0rp/ale'
" Filetypes
Plug 'cespare/vim-toml'
Plug 'cmcaine/vim-uci'
Plug 'zchee/vim-flatbuffers'
Plug 'fatih/vim-go'
Plug 'jamessan/vim-gnupg'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
Plug 'lifepillar/pgsql.vim'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'slim-template/vim-slim'
Plug 'tmatilai/gitolite.vim'
Plug 'zah/nim.vim'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'peter-edge/vim-capnp'
Plug 'vim-scripts/ebnf.vim'
Plug 'ledger/vim-ledger'
" Utils
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'jlanzarotta/bufexplorer'
call plug#end()

colorscheme solarized8
set background=dark
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

let g:ale_sign_column_always = 1
let g:ale_linters = {
			\ 'javascript': ['standard'],
			\ 'yaml': ['cfn-python-lint']
			\ }
"let g:ale_linters_explicit = 1

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
"nnoremap <leader>b :b <C-d>
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
autocmd! bufwritepost init.vim source ~/.config/nvim/init.vim

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
    color solarized8
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
autocmd Filetype fbs setlocal ts=2 sw=2
autocmd Filetype yaml setlocal ts=2 sw=2

autocmd FileType ledger noremap { ?^\d<CR>
autocmd FileType ledger noremap } /^\d<CR>
"autocmd FileType ledger inoremap <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
autocmd FileType ledger vnoremap <silent> <Tab> :LedgerAlign<CR>

" Jump to last known position
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \ exe "normal! g`\"" | endif
