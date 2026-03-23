-- lsp.lua - LSP configuration

local M = {}

M.setup_global_defaults = function()
  vim.lsp.config('*', {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    root_markers = { '.git' },
    exit_timeout = 1000,
  })
end

M.on_attach = function(client, bufnr)
  -- Highlight symbol under cursor
  if client:supports_method('textDocument/documentHighlight') then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Code lens
  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end

  -- Color preview
  if client:supports_method('textDocument/documentColor') then
    vim.lsp.document_color.enable(true, { bufnr = bufnr })
  end

  -- Inlay hints (disabled by default)
  -- if client:supports_method('textDocument/inlayHint') then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end

  -- Native completion (only if blink not available)
  if not pcall(require, 'blink.cmp') and client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  vim.notify('Inlay hints ' .. (not enabled and 'enabled' or 'disabled'))
end

return M
