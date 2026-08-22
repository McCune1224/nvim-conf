-- ============================================================================
-- Colorscheme Collection ("the group box")
-- hearthglass: deepwhite structure with ember colors, dark/light variants.
-- A large bundle of colorschemes is installed so you can switch looks freely.
-- hearthglass stays the default (line ~95); uncomment any `:colorscheme` in the
-- "Switch here" section to try another one.
-- ============================================================================

-- Install all colorschemes
vim.pack.add {
  -- Core dependency for some themes
  'https://github.com/rktjmp/lush.nvim',

  -- ------------------------------------------------------------------
  -- hearthglass (default) + its ember lineage
  -- hearthglass is loaded from the local dev repo via runtimepath below,
  -- so edits in ~/Code/hearthglass.nvim are live immediately.
  -- ------------------------------------------------------------------
  { src = 'https://github.com/ember-theme/nvim', name = 'ember' },
  'https://github.com/Verf/deepwhite.nvim',

  -- ------------------------------------------------------------------
  -- Warm / amber family (fits hearthglass's golden-amber identity)
  -- ------------------------------------------------------------------
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/sainnhe/gruvbox-material',
  'https://github.com/sainnhe/everforest',
  'https://github.com/savq/melange-nvim',
  'https://github.com/blazkowolf/gruber-darker.nvim',
  'https://github.com/rose-pine/neovim',

  -- ------------------------------------------------------------------
  -- Cool / deep-dark family
  -- ------------------------------------------------------------------
  'https://github.com/catppuccin/nvim',
  'https://github.com/AlexvZyl/nordic.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/nyoom-engineering/oxocarbon.nvim',
  'https://github.com/gmr458/cold.nvim',
  'https://github.com/webhooked/kanso.nvim',
  'https://github.com/lucasadelino/conifer.nvim',

  -- ------------------------------------------------------------------
  -- Light / paper family
  -- ------------------------------------------------------------------
  'https://github.com/craftzdog/solarized-osaka.nvim',
  'https://github.com/mcchrish/zenbones.nvim',

  -- ------------------------------------------------------------------
  -- Neutral / monochrome family
  -- ------------------------------------------------------------------
  'https://github.com/aktersnurra/no-clown-fiesta.nvim',
  'https://github.com/slugbyte/lackluster.nvim',
  'https://github.com/xero/miasma.nvim',
  'https://github.com/stevedylandev/darkmatter-nvim',
  'https://github.com/kvrohit/rasmus.nvim',

  -- ------------------------------------------------------------------
  -- Classic / familiar family
  -- ------------------------------------------------------------------
  'https://github.com/Mofiqul/vscode.nvim',
  'https://github.com/rmehri01/onenord.nvim',
  'https://github.com/navarasu/onedark.nvim',
  'https://github.com/Mofiqul/dracula.nvim',
  'https://github.com/bettervim/yugen.nvim',
  -- 'https://github.com/ntpeters/base16-vim',
  -- 'https://github.com/davidosomething/vim-colors-meh',
}

-- Time-based hearthglass selection
-- 9am-3pm: use the light variant; otherwise use the dark variant.
-- local current_time = tonumber(os.date '%H')
--
-- if current_time >= 9 and current_time <= 15 then
--   vim.cmd 'colorscheme hearthglass-light'
-- else
--   vim.cmd 'colorscheme hearthglass'
-- end

-- Load hearthglass from the local dev repo so theme edits are live immediately.
-- (Swap back to `vim.pack.add 'https://github.com/McCune1224/hearthglass.nvim'`
-- and remove this line once hearthglass is published and you want the managed copy.)
vim.opt.runtimepath:prepend('/home/mckusa/Code/hearthglass.nvim')

vim.cmd 'colorscheme hearthglass-auto'

-- ----------------------------------------------------------------------
-- Switch here — uncomment any line to try a different scheme
-- ----------------------------------------------------------------------
-- vim.cmd 'colorscheme hearthglass'
-- vim.cmd 'colorscheme hearthglass-light'
-- vim.cmd 'colorscheme tokyonight-night'
-- vim.cmd 'colorscheme kanagawa'
-- vim.cmd 'colorscheme gruvbox-material'
-- vim.cmd 'colorscheme everforest'
-- vim.cmd 'colorscheme melange'
-- vim.cmd 'colorscheme gruber-darker'
-- vim.cmd 'colorscheme rose-pine'
-- vim.cmd 'colorscheme catppuccin'
-- vim.cmd 'colorscheme nordic'
-- vim.cmd 'colorscheme nightfox'
-- vim.cmd 'colorscheme oxocarbon'
-- vim.cmd 'colorscheme cold'
-- vim.cmd 'colorscheme kanso'
-- vim.cmd 'colorscheme conifer'
-- vim.cmd 'colorscheme solarized-osaka'
-- vim.cmd 'colorscheme zenbones'
-- vim.cmd 'colorscheme no-clown-fiesta'
-- vim.cmd 'colorscheme lackluster'
-- vim.cmd 'colorscheme miasma'
-- vim.cmd 'colorscheme darkmatter'
-- vim.cmd 'colorscheme rasmus'
-- vim.cmd 'colorscheme vscode'
-- vim.cmd 'colorscheme onenord'
-- vim.cmd 'colorscheme onedark'
-- vim.cmd 'colorscheme dracula'
-- vim.cmd 'colorscheme yugen'
-- vim.cmd 'colorscheme base16-tomorrow-night'
