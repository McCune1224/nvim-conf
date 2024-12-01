return {

  { 'rktjmp/lush.nvim' },
  {
    'mcchrish/zenbones.nvim',
  },
  { 'ntk148v/komau.vim' },
  { 'davidosomething/vim-colors-meh' },
  { 'Mofiqul/vscode.nvim' },
  { 'rmehri01/onenord.nvim' },
  { 'Mofiqul/dracula.nvim' },
  { 'fenetikm/falcon' },
  { 'xero/miasma.nvim' },
  { 'aktersnurra/no-clown-fiesta.nvim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'savq/melange-nvim' },
  { 'blazkowolf/gruber-darker.nvim' },
  {
    'rebelot/kanagawa.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- check if current time is 4:00PM, if so use night time theme
      local current_time = tonumber(os.date '%H')
      if current_time >= 16 or current_time < 6 then
        vim.cmd [[colorscheme no-clown-fiesta]]
        return
      end
      vim.cmd [[colorscheme kanagawa-lotus]]
    end,
  },
}
