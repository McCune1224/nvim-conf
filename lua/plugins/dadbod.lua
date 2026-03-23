-- ============================================================================
-- Dadbod Configuration
-- Database UI and completion
-- ============================================================================

-- Install plugins
vim.pack.add({
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
})

-- Enable nerd fonts for DBUI
vim.g.db_ui_use_nerd_fonts = 1

-- Keymaps
vim.keymap.set('n', '<leader>db', '<cmd>DBUIToggle<cr>', { desc = 'Database Open' })
