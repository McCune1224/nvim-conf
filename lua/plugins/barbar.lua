-- return {
--   'romgrk/barbar.nvim',
--   dependencies = {
--     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
--     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
--   },
--   init = function()
--     vim.g.barbar_auto_setup = false
--
--     vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = 'Buffer Pick' })
--     vim.keymap.set('n', '<leader>bd', '<Cmd>BufferClose<CR>', { desc = 'Close Buffer' })
--     vim.keymap.set('n', '<leader>br', '<Cmd>BufferRestore<CR>', { desc = 'Restore Buffer' })
--     vim.keymap.set('n', '<S-h>', '<Cmd>BufferPrevious<CR>', { desc = 'Prev Buffer' })
--     vim.keymap.set('n', '<S-l>', '<Cmd>BufferNext<CR>', { desc = 'Next Buffer' })
--     vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', { desc = 'Order Buffer By Name' })
--     vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = 'Order Buffer By Language' })
--     vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPin<CR>', { desc = 'Pin Buffer' })
--     vim.keymap.set('n', '<leader>bdo', '<Cmd>BufferCloseAllButCurrent<CR>', { desc = 'Delete All Other Buffers But Current' })
--     vim.keymap.set('n', '<leader>bdv', '<Cmd>BufferCloseAllButVisible<CR>', { desc = 'Delete All Other Buffers But Visible' })
--     vim.keymap.set('n', '<leader>bdp', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', { desc = 'Delete All Other Buffers But Current Or Pinned' })
--     vim.keymap.set('n', '<leader>bs', '<Cmd>BufferPick<CR>', { desc = 'Magic Buffer Pick' })
--   end,
--   opts = {
--     -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
--     -- animation = true,
--     -- insert_at_start = true,
--     -- …etc.
--     sort = {
--       ignore_case = true,
--     },
--   },
--   version = '^1.0.0', -- optional: only update when a new 1.x version is released
-- }

return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false

      vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = 'Buffer Pick' })
      vim.keymap.set('n', '<leader>bd', '<Cmd>BufferClose<CR>', { desc = 'Close Buffer' })
      vim.keymap.set('n', '<leader>br', '<Cmd>BufferRestore<CR>', { desc = 'Restore Buffer' })
      vim.keymap.set('n', '<S-h>', '<Cmd>BufferPrevious<CR>', { desc = 'Prev Buffer' })
      vim.keymap.set('n', '<S-l>', '<Cmd>BufferNext<CR>', { desc = 'Next Buffer' })
      vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', { desc = 'Order Buffer By Name' })
      vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = 'Order Buffer By Language' })
      vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPin<CR>', { desc = 'Pin Buffer' })
      vim.keymap.set('n', '<leader>bdo', '<Cmd>BufferCloseAllButCurrent<CR>', { desc = 'Delete All Other Buffers But Current' })
      vim.keymap.set('n', '<leader>bdv', '<Cmd>BufferCloseAllButVisible<CR>', { desc = 'Delete All Other Buffers But Visible' })
      vim.keymap.set('n', '<leader>bdp', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', { desc = 'Delete All Other Buffers But Current Or Pinned' })
      vim.keymap.set('n', '<leader>bs', '<Cmd>BufferPick<CR>', { desc = 'Magic Buffer Pick' })
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
}
