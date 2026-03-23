-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', {}),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Format on save for Go files
autocmd('BufWritePre', {
  pattern = '*.go',
  group = augroup('go_format', {}),
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- LSP Attach - use centralized LSP config
autocmd('LspAttach', {
  group = augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    require('config.lsp').on_attach(client, ev.buf)
  end,
})
