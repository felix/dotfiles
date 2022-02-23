set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

lua << EOF
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end  -- Mappings.
	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
end


local cmp = require'cmp'
cmp.setup({
mapping = {
	['<C-Space>'] = cmp.mapping.confirm {
		behavior = cmp.ConfirmBehavior.Insert,
		select = true,
		},

	['<Tab>'] = function(fallback)
		if not cmp.select_next_item() then
			if vim.bo.buftype ~= 'prompt' and has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end
	end,

	['<S-Tab>'] = function(fallback)
		if not cmp.select_prev_item() then
			if vim.bo.buftype ~= 'prompt' and has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end
	end,
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
require'lspconfig'.tsserver.setup {
	on_attach = on_attach
}
EOF
