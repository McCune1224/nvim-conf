-- ============================================================================
-- OPTIONS
-- ============================================================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Display
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }

-- Clipboard
opt.clipboard = 'unnamedplus'
