set background=dark
set colorcolumn=81
set cursorline
set ignorecase
set list
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set number
set smartcase
set spelllang=en_au
set statusline=%F%m%r%h%w[%{&ff}]%y[%p%%][%l/%L,%v]
set whichwrap+=<,>,h,l,[,]
colorscheme desert

if has('nvim')
	set clipboard=unnamedplus
	if system('uname -s') == "Darwin\n"
		set clipboard=unnamed
	endif
else
	syntax enable sync minlines=20
	filetype indent plugin on
	set hlsearch
	set incsearch
	set laststatus=2
	set nocompatible
	set ttyfast
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
	let &undodir = expand('$HOME/.vim/undo')
	call system('mkdir -p ' . &undodir)
	set undofile
endif

nnoremap <F2> :set nonumber<CR>:set nofoldenable<CR>:set nolist<CR>:set paste<CR>
nnoremap <F3> :set number<CR>:set foldenable<CR>:set list<CR>:set nopaste<CR>
"nnoremap <leader>s :call StripTrailingWhitespace()<cr>
nnoremap <leader>s :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
nnoremap <leader>f gqap

call plug#begin('~/.vim/plugged')
Plug 'overcache/NeoSolarized'
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'godlygeek/tabular'
Plug 'jlanzarotta/bufexplorer'
Plug 'ledger/vim-ledger'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
if has('nvim')
Plug 'L3MON4D3/LuaSnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'saadparwaiz1/cmp_luasnip'
endif
call plug#end()

if (has("termguicolors"))
	set termguicolors
	colorscheme NeoSolarized
endif

let g:ansible_unindent_after_newline=1
let g:go_auto_type_info = 1
let g:go_metalinter_command='golangci-lint'
let g:ledger_date_format='%Y-%m-%d'

autocmd BufRead,BufNewFile *.m4 setlocal ft=m4
autocmd BufRead,BufNewFile *.tmpl setlocal ft=gohtmltmpl
autocmd BufRead,BufNewFile *mutt* setlocal ft=mail
autocmd FileType ledger inoremap <silent> <Tab> <C-r>=ledger#autocomplete_and_align()<CR>
autocmd FileType ledger noremap { ?^\d<CR>
autocmd FileType ledger noremap } /^\d<CR>
autocmd FileType ledger setlocal ts=4 sw=4 et
autocmd FileType ledger vnoremap <silent> <Tab> :LedgerAlign<CR>
autocmd FileType php setlocal ts=4 sw=4 et
autocmd Filetype html setlocal ts=2 sw=2 et
autocmd Filetype javascript setlocal ts=2 sw=2 et nowrap
autocmd Filetype json setlocal ts=2 sw=2 et nowrap
autocmd Filetype mail setlocal nohlsearch spell nobackup noswapfile nowritebackup noautoindent
autocmd Filetype markdown setlocal spell
autocmd Filetype yaml setlocal ts=2 sw=2
