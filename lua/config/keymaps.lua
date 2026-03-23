-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format buffer' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count = -1}) end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count = 1}) end, { desc = 'Next diagnostic' })

-- LSP Features
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Run code lens' })
vim.keymap.set('n', '<leader>ih', function()
  require('config.lsp').toggle_inlay_hints()
end, { desc = 'Toggle inlay hints' })

-- Mason
vim.keymap.set('n', '<leader>m', ':Mason<cr>', { desc = 'Open Mason' })

-- File operations
vim.keymap.set('n', '<leader>e', vim.cmd.Ex, { desc = 'Open file explorer' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Buffer navigation
vim.keymap.set('n', '<S-h>', ':bprevious<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<S-l>', ':bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<cr>', { desc = 'Delete buffer' })

-- Clear search highlight
vim.keymap.set('n', '<esc><esc>', ':nohlsearch<cr>', { desc = 'Clear search highlight' })
