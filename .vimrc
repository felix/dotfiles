set background=dark
set ignorecase
set list
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set mouse=a
set number
set smartcase
set spelllang=en_au
set statusline=%F%m%r%h%w[%{&ff}]%y[%p%%][%l/%L,%v]
set termguicolors
set textwidth=80
set whichwrap+=<,>,h,l,[,]
colorscheme habamax

if has('nvim')
	set clipboard=unnamedplus
	if system('uname -s') == "Darwin\n"
		set clipboard=unnamed
	endif
else
	" I believe these are defaults for nvim
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

" Clear screen for copying using F2, restore using F3
nnoremap <F2> :set nonumber<CR>:set nofoldenable<CR>:set nolist<CR>:set paste<CR>
nnoremap <F3> :set number<CR>:set foldenable<CR>:set list<CR>:set nopaste<CR>
" Strip trailing whitespace
nnoremap <leader>s :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Format paragrapha
nnoremap <leader>f gqap
" List buffers
nnoremap <Leader>b :ls<CR>:b<space>
" gofmt and goimports
nnoremap <Leader>g :%!goimports && gofmt<CR>
" lint
nnoremap <Leader>l :make lint \| cwindow<CR>

if executable("rg")
	set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
	set grepformat=%f:%l:%c:%m
	set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

autocmd BufRead,BufNewFile *.tmpl setlocal ft=gohtmltmpl
autocmd BufRead,BufNewFile *mutt-* setlocal ft=mail.markdown
autocmd BufRead,BufNewFile *.ddd setlocal ft=json
autocmd Filetype mail setlocal nohlsearch spell nobackup noswapfile nowritebackup noautoindent
autocmd Filetype markdown setlocal spell

" Restore file position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" For mail, jump past headers and insert
autocmd BufRead *mutt-* execute "normal /^$/\n"
autocmd BufRead *mutt-* execute ":startinsert"
