-- ============================================================================
-- Dadbod Configuration
-- Database UI and completion
-- ============================================================================

-- Install plugins
vim.pack.add({
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
})

-- Enable nerd fonts for DBUI
vim.g.db_ui_use_nerd_fonts = 1

-- Keymaps
vim.keymap.set('n', '<leader>db', '<cmd>DBUIToggle<cr>', { desc = '[D]ata[B]ase Open' })
