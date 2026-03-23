-- ============================================================================
-- Tokyonight Colorscheme Configuration
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })

-- Setup
local ok_tokyonight, tokyonight = pcall(require, 'tokyonight')
if ok_tokyonight then
  vim.cmd('colorscheme tokyonight')
else
  vim.cmd('colorscheme default')
end
