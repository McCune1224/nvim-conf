return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {
      attach_mode = 'global',
      backends = { 'treesitter', 'lsp', 'markdown', 'man' },
      layout = {
        min_width = 30,
        default_direction = 'prefer_right',
      },
      show_guides = true,
      filter_kind = false,
      keymaps = {
        ['<CR>'] = 'actions.jump',
        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-s>'] = 'actions.jump_split',
      },
    }

    vim.keymap.set('n', '<leader>cs', '<cmd>AerialToggle!<CR>', { desc = '[C]ode [S]ymbols' })
  end,
}
