-- options.lua - Settings

local opt = vim.opt

-- Editor basics
opt.autowrite = true
opt.confirm = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'

-- Visuals
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmode = false
opt.laststatus = 3
opt.signcolumn = 'yes'
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
  stl = '─',
  stlnc = '─',
}

-- Scrolling
opt.scrolloff = math.floor(0.3 * vim.o.lines)
opt.sidescrolloff = 14
opt.smoothscroll = true
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = 'screen'

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.grepprg = 'rg --vimgrep'
opt.grepformat = '%f:%l:%c:%m'

-- Completion
opt.completeopt = 'menu,menuone,noselect,noinsert,popup'
opt.wildmode = 'longest:full,full'
opt.pumblend = 0

-- Messages
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.conceallevel = 2

-- Folds
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = '0'

-- Spell
opt.spelllang = { 'en' }
opt.spell = false

-- Sessions
opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }

-- Mouse
opt.mouse = 'a'

-- Wrapping
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- Virtual edit
opt.virtualedit = 'block'

-- Window min size
opt.winminwidth = 5
opt.winminheight = 1

-- Windows shell
if vim.fn.has 'win32' == 1 then
  opt.shell = 'pwsh'
  opt.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  opt.shellquote = ''
  opt.shellxquote = ''
end

-- Fix markdown
vim.g.markdown_recommended_style = 0
