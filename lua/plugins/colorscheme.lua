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
  { 'rebelot/kanagawa.nvim' },
  {
    'olivercederborg/poimandres.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      -- Get current time to see if its 5pm or not:
      local current_time = tonumber(os.date '%H')
      local p = require 'poimandres.palette'
      require('poimandres').setup {
        -- Without this the highlight is borderline identical to the text,
        -- so just setting it to the background color
        highlight_groups = {
          LspReferenceText = { bg = p.background1 },
          LspReferenceRead = { bg = p.background1 },
          LspReferenceWrite = { bg = p.background1 },
        },
        -- leave this setup empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }

      if current_time >= 16 or current_time < 6 then
        vim.cmd [[colorscheme no-clown-fiesta]]
        return
      end
      vim.cmd [[colorscheme poimandres]]
    end,
  },
}
