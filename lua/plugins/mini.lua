-- ============================================================================
-- Mini.nvim Configuration
-- Lightweight utility modules
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

-- Setup modules
local ok_mini_ai = pcall(require, 'mini.ai')
if ok_mini_ai then require('mini.ai').setup() end

local ok_mini_pairs = pcall(require, 'mini.pairs')
if ok_mini_pairs then require('mini.pairs').setup() end

local ok_mini_surround = pcall(require, 'mini.surround')
if ok_mini_surround then require('mini.surround').setup() end

local ok_mini_comment = pcall(require, 'mini.comment')
if ok_mini_comment then require('mini.comment').setup() end

-- local ok_mini_statusline = pcall(require, 'mini.statusline')
-- if ok_mini_statusline then require('mini.statusline').setup() end
