-- ============================================================================
-- Oil.nvim Configuration
-- File explorer as a buffer
-- ============================================================================

-- Install plugins
vim.pack.add({
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
})

-- Remove colorcolumn in oil buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.opt_local.colorcolumn = ''
  end,
})

-- Setup oil
local ok_oil, oil = pcall(require, 'oil')
if not ok_oil then
  return
end

oil.setup({
  use_default_keymaps = true,
  view_options = {
    show_hidden = true,
  },
})

-- Keymaps
vim.keymap.set('n', '<C-->', '<cmd>Oil<CR>', { desc = 'Open Explorer' })
