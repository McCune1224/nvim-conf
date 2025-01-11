-- Highlight todo, notes, etc in comments
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = true },
  keys = {
    { '<leader>tx', ':TodoTrouble<CR>', '[T]odo [X]Trouble}' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
