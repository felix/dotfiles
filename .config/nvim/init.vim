set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

lua << EOF
require'lspconfig'.gopls.setup{
	on_attach=require'completion'.on_attach
}
require'lspconfig'.pyright.setup{}
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	-- ignore_install = { "c_sharp" },
	highlight = {
		enable = true
		-- disable = { "c", "rust" },
	},
	indent = {
		enable = true
	}
}
EOF
