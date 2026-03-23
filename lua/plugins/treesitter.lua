-- ============================================================================
-- Treesitter Configuration
-- Syntax highlighting and indentation
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

-- Setup
local ok_treesitter, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok_treesitter then
  return
end

treesitter.setup({
  ensure_installed = { 'go', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
  highlight = { enable = true },
  indent = { enable = true },
})
