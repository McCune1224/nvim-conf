-- ============================================================================
-- Mason Configuration
-- LSP server installer
-- ============================================================================

-- Install plugin
vim.pack.add({
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
})

-- Setup
local ok_mason, mason = pcall(require, 'mason')
if not ok_mason then
  return
end

mason.setup()

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
    },
    automatic_enable = false,
  })
end


-- test
