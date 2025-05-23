return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  keys = {
    -- { '<leader>wn', '<CMD>:NoNeckPain<CR>', desc = '[W]indow [N]eckpain (center)' },
    { '<leader>z', '<CMD>:NoNeckPain<CR>', desc = '[W]indow [N]eckpain (center)' },
  },

  -- opts = {
  --   buffers = {
  --     scratchPad = {
  --       -- set to `false` to
  --       -- disable auto-saving
  --       enabled = true,
  --       -- set to `nil` to default
  --       -- to current working directory
  --       location = nil,
  --     },
  --     bo = {
  --       filetype = 'md',
  --     },
  --   },
  -- },
  opts = {
    width = math.floor(0.6 * vim.o.columns),
    buffers = {
      colors = { blend = -0.8 },
      left = {
        scratchPad = {
          enabled = true,
          pathToFile = '~/Documents/nvim_scratchpad.md',
          -- pathToFile = nil,
        },
        bo = {
          filetype = 'md',
        },
      },
    },
  },
}
--
