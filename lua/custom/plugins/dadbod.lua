return {
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  "kristijanhusak/vim-dadbod-ui",

  keys = {
    {
      '<leader>do',
      '<cmd>DBUIToggle<cr>',
      desc = 'Database Open',
    },
  },

  init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
}
