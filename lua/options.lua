local opt = vim.opt

opt.autowrite = true -- Enable auto write

if not vim.env.SSH_TTY then
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  opt.clipboard = 'unnamedplus' -- Sync with system clipboard
end

opt.completeopt = 'menu,menuone,noselect'
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = 'jcroqlnt' -- tcqj
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.ignorecase = true -- Ignore case
opt.inccommand = 'nosplit' -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.mouse = 'a' -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 20 -- Popup blend
opt.pumheight = 20 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 15 -- Lines of context
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 14 -- Columns of context
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { 'en' }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = 'screen'
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
if not vim.g.vscode then
  opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
end
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
opt.foldenable = false -- disable folding
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

vim.opt.guicursor = 'n-v-c:block,i-ci-ve:hor20,r-cr:hor20,o:hor50'

-- NIXOS NO LIKEY
opt.smoothscroll = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
--
-- -- [[ Setting options ]]
-- -- See `:help vim.opt`
-- -- NOTE: You can change these options as you wish!
-- --  For more options, you can see `:help option-list`
--
-- -- Make line numbers default
-- vim.opt.number = true
-- -- You can also add relative line numbers, to help with jumping.
-- --  Experiment for yourself to see if you like it!
-- -- vim.opt.relativenumber = true
--
-- -- Enable mouse mode, can be useful for resizing splits for example!
-- vim.opt.mouse = 'a'
--
-- -- Don't show the mode, since it's already in the status line
-- vim.opt.showmode = false
--
-- -- Sync clipboard between OS and Neovim.
-- --  Remove this option if you want your OS clipboard to remain independent.
-- --  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'
--
-- -- Enable break indent
-- vim.opt.breakindent = true
--
-- -- Save undo history
-- vim.opt.undofile = true
--
-- -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
-- vim.opt.ignorecase = true
-- vim.opt.smartcase = true
--
-- -- Keep signcolumn on by default
-- vim.opt.signcolumn = 'yes'
--
-- -- Decrease update time
-- vim.opt.updatetime = 250
--
-- -- Decrease mapped sequence wait time
-- -- Displays which-key popup sooner
-- vim.opt.timeoutlen = 300
--
-- -- Configure how new splits should be opened
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
--
-- -- Sets how neovim will display certain whitespace characters in the editor.
-- --  See `:help 'list'`
-- --  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
--
-- -- Preview substitutions live, as you type!
-- vim.opt.inccommand = 'split'
--
-- -- Show which line your cursor is on
-- vim.opt.cursorline = true
--
-- -- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10
--
-- vim.opt.swapfile = false -- disable swap files
-- vim.opt.scrolloff = 14 -- keep cursor centered when scrolling up and down
-- vim.opt.sidescrolloff = 6 -- keep cursor centered
-- vim.opt.termguicolors = true -- set term gui colors most terminals support this

-- vim: ts=2 sts=2 sw=2 et
