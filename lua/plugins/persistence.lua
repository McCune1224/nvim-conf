-- ============================================================================
-- Persistence Configuration
-- Session management with automatic save/restore
-- ============================================================================

vim.pack.add({ 'https://github.com/folke/persistence.nvim' })

local ok_persistence, persistence = pcall(require, 'persistence')
if not ok_persistence then
  vim.notify('persistence.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

persistence.setup({
  dir = vim.fn.stdpath('state') .. '/sessions/',
  options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' },
  save_empty = false,
})

vim.keymap.set('n', '<leader>qs', function() persistence.load() end, { desc = '[Q]uick [S]ession restore' })
vim.keymap.set('n', '<leader>ql', function() persistence.load({ last = true }) end, { desc = '[Q]uick [L]ast session' })
vim.keymap.set('n', '<leader>qd', function() persistence.stop() end, { desc = '[Q]uick [D]on\'t save' })
