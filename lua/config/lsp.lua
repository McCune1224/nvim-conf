-- ============================================================================
-- LSP Configuration - Sane defaults
-- All features enabled except ghost text / inline hints
-- ============================================================================

local M = {}

-- Global LSP defaults
M.setup_global_defaults = function()
  vim.lsp.config('*', {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    root_markers = { '.git' },
    exit_timeout = 5000,
  })
end

-- Enable all sane LSP features for a buffer
-- Called from LspAttach autocmd
M.on_attach = function(client, bufnr)
  -- Document highlight (highlight word under cursor)
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

  -- Code lens (displayed as virtual lines in 0.12)
  if client:supports_method('textDocument/codeLens') then
    vim.lsp.codelens.enable(true, { bufnr = bufnr })
  end

  -- Document color (color preview)
  if client:supports_method('textDocument/documentColor') then
    vim.lsp.document_color.enable(true, bufnr)
  end

  -- Inlay hints - DISABLED by default (user preference)
  -- if client:supports_method('textDocument/inlayHint') then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end

  -- Completion - only if blink is not available
  local has_blink = pcall(require, 'blink.cmp')
  if not has_blink and client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end

  -- Auto format on save (opt-in per filetype via autocmd)
  -- See autocmds.lua for Go format on save
end

-- Toggle inlay hints (manual opt-in)
M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  vim.notify('Inlay hints ' .. (not enabled and 'enabled' or 'disabled'))
end

return M
