return {
  'MagicDuck/grug-far.nvim',
  keymaps = {
    { '<leader>g', '<cmd>GrugFar<cr>', desc = 'GRUG TIME' },
  },
  config = function()
    require('grug-far').setup {}
  end,
}
