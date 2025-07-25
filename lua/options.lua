local opt = vim.opt

opt.autowrite = true -- Enable auto write

if not vim.env.SSH_TTY then
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  opt.clipboard = 'unnamedplus' -- Sync with system clipboard
end

opt.completeopt = 'menu,menuone,noselect,noinsert,popup'
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
-- opt.listchars = { trail = '·', nbsp = '␣' }
opt.mouse = 'a' -- Enable mouse mode
opt.number = true -- Print line number
-- opt.pumblend = 20 -- Popup blend
-- opt.pumheight = 20 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
-- opt.scrolloff = 8 -- Lines of context
opt.scrolloff = math.floor(0.3 * vim.o.lines)
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
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

-- opt.guicursor = 'n-v-c:block,i-ci-ve:hor20,r-cr:hor20,o:hor50' -- underscore '_' cursor while on insert mode
-- check if on windows and if so, set to use powershell:
if vim.fn.has 'win32' == 1 then
  -- Set PowerShell as default shell
  opt.shell = 'pwsh'
  opt.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  opt.shellquote = ''
  opt.shellxquote = ''
end
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.wrap = false -- Disable line wrap
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
  -- stl = '─',
  -- stlnc = '─',
}
opt.smoothscroll = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
