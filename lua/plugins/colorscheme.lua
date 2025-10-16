return {

  { 'rktjmp/lush.nvim' },
  {
    'mcchrish/zenbones.nvim',
  },
  { 'davidosomething/vim-colors-meh' },
  { 'Mofiqul/vscode.nvim' },
  { 'rmehri01/onenord.nvim' },
  { 'xero/miasma.nvim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'savq/melange-nvim' },
  { 'blazkowolf/gruber-darker.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'slugbyte/lackluster.nvim' },
  { 'sainnhe/gruvbox-material' },
  { 'bettervim/yugen.nvim' },
  { 'webhooked/kanso.nvim' },
  { 'aktersnurra/no-clown-fiesta.nvim' },
  { 'stevedylandev/darkmatter-nvim' },
  { 'Verf/deepwhite.nvim' },
  { 'lucasadelino/conifer.nvim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'gmr458/cold.nvim' },
  {
    'webhooked/kanso.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Get current time to see if its 5pm or not:
      local current_time = tonumber(os.date '%H')
      if current_time >= 9 and current_time <= 16 then
        vim.cmd [[colorscheme deepwhite]]
      else
        vim.cmd [[colorscheme confier]]
      end
      -- vim.cmd [[colorscheme cold]]
    end,
  },
}
