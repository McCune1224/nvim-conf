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

      -- Traverse Buffers
      vim.keymap.set('n', '<S-h>', '<Cmd>BufferPrevious<CR>', { desc = 'Prev Buffer' })
      vim.keymap.set('n', '<S-l>', '<Cmd>BufferNext<CR>', { desc = 'Next Buffer' })

      -- Closing Buffers
      vim.keymap.set('n', '<leader>bd', '<Cmd>BufferClose<CR>', { desc = '[B]uffer [D]elete [C]urrent' })
      vim.keymap.set('n', '<leader>bD', '<Cmd>BufferCloseAllButCurrent<CR>', { desc = '[B]uffer [D]elete [O]thers' })
      vim.keymap.set('n', '<leader>bv', '<Cmd>BufferCloseAllButVisible<CR>', { desc = '[B]uffer [D]elete non-[V]isible' })
      vim.keymap.set('n', '<leader>bP', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', { desc = '[B]uffer [D]elete non-[P]inned & Current' })
      vim.keymap.set('n', '<leader>br', '<Cmd>BufferRestore<CR>', { desc = '[B]uffer [R]estore' })

      vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPin<CR>', { desc = '[B]uffer [P]in' })
      vim.keymap.set('n', '<leader>bn', '<Cmd>BufferOrderByName<CR>', { desc = '[B]uffer Order by [N]ame' })
      vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = '[B]uffer Order by [L]anguage' })
      vim.keymap.set('n', '<leader>bs', '<Cmd>BufferPick<CR>', { desc = '[B]uffer [S]elect' })
    end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      animation = true,
      -- insert_at_start = true,
      -- …etc.
      icons = {
        filetype = {},
        separator = { left = ' 󱅄 ' },
        pinned = { button = '', filename = true },
        preset = 'default',
      },
    },
    -- version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
}
