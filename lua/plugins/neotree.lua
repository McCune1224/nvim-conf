return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },

  keys = {
    { '<C-\\>', ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
  },

  opts = {
    filesystem = {
      window = {
        position = 'right',
        width = 50,
        mappings = {
          ['<C-\\>'] = 'close_window',
        },
      },
    },
  },
}
