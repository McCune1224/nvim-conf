-- ============================================================================
-- Autocommands Configuration
-- Event-driven behaviors
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Detect Svelte filetype
autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup('svelte_ft', {}),
  pattern = '*.svelte',
  callback = function()
    vim.bo.filetype = 'svelte'
  end,
})

-- Highlight yanked text
autocmd('TextYankPost', {
  group = augroup('highlight_yank', {}),
  callback = function() vim.hl.on_yank() end,
})

-- LSP attach
autocmd('LspAttach', {
  group = augroup('UserLspConfig', {}),
  callback = function(ev)
    require('config.lsp').on_attach(
      vim.lsp.get_client_by_id(ev.data.client_id),
      ev.buf
    )
  end,
})

-- Refresh statusline on file/git changes
autocmd({ 'BufWritePost', 'BufModifiedSet', 'User' }, {
  group = augroup('lualine_refresh', {}),
  callback = function()
    vim.schedule(function() pcall(vim.cmd, 'redrawstatus') end)
  end,
})
