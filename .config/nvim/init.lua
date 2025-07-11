-- Share vim configuration
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

vim.diagnostic.config({
	-- Show diagnostic text inline
	virtual_text = true,
})

vim.lsp.config('gopls', {
	filetypes = { 'go' },
	cmd = { 'gopls' },
	root_markers = { 'go.mod', 'go.work' }
})
vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Enable inlay hints',
  callback = function(event)
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil or not client.supports_method('textDocument/inlayHint') then
      return
    end

    vim.lsp.inlay_hint.enable(true, {bufnr = event.buf})
  end,
})

-- Neovim keybindings by default:
-- <C-w>d: floating diagnostics window
-- [d, ]d: prev and next diagnostics
-- K: show docs for symbol under cursor
-- grn: renames references
-- gra: show LSP actions
-- grr: show references
-- gri: show implementations
-- gO: lists symbols in buffer
-- <C-s>: shows signature
-- <C-]>: jump to definition
