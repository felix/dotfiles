set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

lua << EOF
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require'cmp'
cmp.setup({
mapping = {
	["<Tab>"] = cmp.mapping(function(fallback)
	if vim.fn.pumvisible() == 1 then
		feedkey("<C-n>", "n")
	elseif has_words_before() then
		cmp.complete()
	else
		fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
	end
end, { "i", "s" }),
},
sources = {
	{ name = 'nvim_lsp' },
	{ name = 'buffer' },
	}
})

require'lspconfig'.gopls.setup{
	-- on_attach=require'completion'.on_attach
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require'lspconfig'.pyright.setup{
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}
require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"go",
		"ledger",
		"svelte",
		"typescript",
		"yaml",
		"zig",
	},
	highlight = {
		enable = true
		-- disable = { "c", "rust" },
	},
	indent = {
		enable = true,
		disable = { 'yaml' }
	}
}
EOF
