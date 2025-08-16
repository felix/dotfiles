filetype indent plugin on         " (vi) enable filetype plugins
set background=dark
set colorcolumn=+1                " highlight column relative to textwidth
"set cursorcolumn                  " highlight the current column
set cursorline                    " highlight the entire current line
set hlsearch                      " (vi) highlight all matches of last search
set ignorecase                    " ignore case of characters for searching etc.
set incsearch                     " (vi) enable incremental searching (get feedback as you type)
set laststatus=2                  " (vi) always show a statusline
set list                          " show special characters
set listchars=extends:»,tab:·\ ,trail:•,nbsp:␣
set mouse=a                       " enable mouse in all modes
set nocompatible                  " (vi) do not preserve compatibility with Vi
set number                        " show line numbers
set smartcase                     " case-sensitive search when mixed case used
set spelllang=en_au
set statusline=%F%m%r%h%w[%{&ff}]%y[%p%%][%l/%L,%v]
set termguicolors                 " enable 24-bit color
set textwidth=80                  " hard wrap at this column
set ttyfast
set whichwrap+=<,>,h,l,[,]        " keys which enable wrapping
set wildmode=list:longest,full    " settings for how to complete matched strings
syntax enable sync minlines=20    " (vi) syntax highlighting using 20 lines
colorscheme habamax

if has('nvim')
	set clipboard=unnamedplus
	if system('uname -s') == "Darwin\n"
		set clipboard=unnamed
	endif
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
	let &undodir = expand('$HOME/.vim/undo')
	call system('mkdir -p ' . &undodir)
	set undofile
endif

if executable("rg")
	set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ -g!vendor
	set grepformat=%f:%l:%c:%m
	set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Common typos
cnoreabbrev W  w
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev E  e

" Completion
set omnifunc=syntaxcomplete#Complete
set complete+=k
set completeopt=menu,menuone,noinsert
inoremap <expr> <Tab> TabComplete()
function! TabComplete()
	if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
		return "\<C-N>"
	else
		return "\<Tab>"
	endif
endfun
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
autocmd InsertCharPre * call AutoComplete()
function! AutoComplete()
	if v:char =~ '\K'
			\ && getline('.')[col('.') - 4] !~ '\K'
			\ && getline('.')[col('.') - 3] =~ '\K'
			\ && getline('.')[col('.') - 2] =~ '\K' " last char
			\ && getline('.')[col('.') - 1] !~ '\K'

	call feedkeys("\<C-N>", 'n')
	end
endfun

" Clear screen for copying using F2, restore using F3
nnoremap <F2> :set nonumber<CR>:set nofoldenable<CR>:set nolist<CR>:set paste<CR>
nnoremap <F3> :set number<CR>:set foldenable<CR>:set list<CR>:set nopaste<CR>
" Strip trailing whitespace
nnoremap <leader>s :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" List buffers
nnoremap <Leader>b :ls<CR>:b<space>
" gofmt
nnoremap <Leader>gf :call GoFmt()<CR>
function! GoFmt()
  let saved_view = winsaveview()
  silent %!gofmt
  if v:shell_error > 0
    cexpr getline(1, '$')->map({ idx, val -> val->substitute('<standard input>', expand('%'), '') })
    silent undo
    cwindow
  endif
  call winrestview(saved_view)
endfunction
" goimports
nnoremap <Leader>gi :call GoImports()<CR>
function! GoImports()
  let saved_view = winsaveview()
  silent %!goimports
  call winrestview(saved_view)
endfunction
" lint
nnoremap <Leader>l :make lint \| cwindow<CR>
" Grep current word
nnoremap <Leader>r :grep <cword> \| cwindow<CR>

autocmd BufRead,BufNewFile *.tmpl setlocal ft=html.gohtmltmpl
autocmd BufRead,BufNewFile *mutt-* setlocal ft=mail.markdown
autocmd BufRead,BufNewFile *.ddd setlocal ft=json
autocmd Filetype mail setlocal nohlsearch spell nobackup noswapfile nowritebackup noautoindent
autocmd Filetype markdown setlocal spell formatoptions=awn

" Restore file position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
" For mail, jump past headers and insert
autocmd BufRead *mutt-* execute "normal /^$/\n"
autocmd BufRead *mutt-* execute ":startinsert"
"autocmd BufWritePre *.go execute ":call GoImports()" | execute ":call GoFmt()"
