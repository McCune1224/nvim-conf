-- ============================================================================
-- Suda Configuration
-- Write files with sudo (handles permission issues)
-- ============================================================================

vim.pack.add({ 'https://github.com/lambdalisue/suda.vim' })

local ok, suda = pcall(require, 'suda')
if not ok then
  return
end

suda.setup({})
