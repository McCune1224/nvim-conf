-- ============================================================================
-- Colorscheme Collection
-- Multiple colorschemes with time-based switching
-- ============================================================================

-- Install all colorschemes
vim.pack.add {
  -- Core dependency for some themes
  'https://github.com/rktjmp/lush.nvim',

  -- Colorschemes
  'https://github.com/mcchrish/zenbones.nvim',
  -- 'https://github.com/davidosomething/vim-colors-meh',
  'https://github.com/Mofiqul/vscode.nvim',
  'https://github.com/rmehri01/onenord.nvim',
  -- 'https://github.com/xero/miasma.nvim',
  'https://github.com/nyoom-engineering/oxocarbon.nvim',
  -- 'https://github.com/savq/melange-nvim',
  -- 'https://github.com/blazkowolf/gruber-darker.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  -- 'https://github.com/slugbyte/lackluster.nvim',
  'https://github.com/sainnhe/gruvbox-material',
  -- 'https://github.com/bettervim/yugen.nvim',
  'https://github.com/webhooked/kanso.nvim',
  'https://github.com/aktersnurra/no-clown-fiesta.nvim',
  -- 'https://github.com/stevedylandev/darkmatter-nvim',
  'https://github.com/Verf/deepwhite.nvim',
  'https://github.com/lucasadelino/conifer.nvim',
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
  'https://github.com/ember-theme/nvim',
  'https://github.com/gmr458/cold.nvim',
  -- 'https://github.com/kvrohit/rasmus.nvim',

  -- Also install tokyonight as fallback
  -- 'https://github.com/folke/tokyonight.nvim',
}

-- Time-based colorscheme selection
-- 9am-3pm: Use lighter theme
-- Other times: Use darker theme
local current_time = tonumber(os.date '%H')

if current_time >= 9 and current_time <= 15 then
  -- Daytime - lighter theme
  -- vim.cmd('colorscheme conifer-lunar')
  vim.cmd 'colorscheme ember'
else
  -- Evening/Night - darker theme
  -- vim.cmd('colorscheme kanso-ink')
  vim.cmd 'colorscheme ember'
end

-- Alternative single colorschemes (uncomment to use):
-- vim.cmd('colorscheme cold')
-- vim.cmd('colorscheme kanagawa')
-- vim.cmd('colorscheme rose-pine')
-- vim.cmd('colorscheme gruvbox-material')
-- vim.cmd('colorscheme vscode')
-- vim.cmd('colorscheme tokyonight')
--
