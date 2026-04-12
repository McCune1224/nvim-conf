-- ============================================================================
-- Mason Configuration
-- LSP server installer with automatic_enable for vim.lsp.enable()
-- ============================================================================

-- Install plugins
vim.pack.add({
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})

-- Setup Mason
local ok_mason, mason = pcall(require, 'mason')
if not ok_mason then
  return
end

mason.setup()

-- Setup mason-lspconfig for automatic LSP installation
local ok_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
if ok_mason_lspconfig then
  mason_lspconfig.setup({
    ensure_installed = {
      'gopls',
      'lua_ls',
      'rust_analyzer',
      'clangd',
      'vtsls',
      'elixirls',
      'omnisharp',
      'tailwindcss',
      'templ',
      'svelte',
      'html',
    },
    automatic_enable = true,
  })
end
