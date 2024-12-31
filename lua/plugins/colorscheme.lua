return {

  { 'rktjmp/lush.nvim' },
  {
    'mcchrish/zenbones.nvim',
  },
  { 'davidosomething/vim-colors-meh' },
  { 'Mofiqul/vscode.nvim' },
  { 'rmehri01/onenord.nvim' },
  { 'xero/miasma.nvim' },
  { 'aktersnurra/no-clown-fiesta.nvim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'savq/melange-nvim' },
  { 'blazkowolf/gruber-darker.nvim' },
  { 'rebelot/kanagawa.nvim' },
  {
    'rebelot/kanagawa.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      -- Get current time to see if its 5pm or not:
      -- local current_time = tonumber(os.date '%H')
      -- if current_time >= 16 or current_time < 6 then
      --   vim.cmd [[colorscheme vscode]]
      --   return
      -- end
      vim.cmd [[colorscheme kanagawa-dragon]]
    end,
  },
}
