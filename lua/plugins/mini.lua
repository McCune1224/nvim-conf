-- ============================================================================
-- Mini.nvim Configuration
-- Essential utility modules (ai, pairs, surround, comment)
-- ============================================================================

vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

-- Setup modules with error handling
local ok_mini_ai = pcall(require, 'mini.ai')
if ok_mini_ai then require('mini.ai').setup() end

local ok_mini_pairs = pcall(require, 'mini.pairs')
if ok_mini_pairs then require('mini.pairs').setup() end

local ok_mini_surround = pcall(require, 'mini.surround')
if ok_mini_surround then require('mini.surround').setup() end

local ok_mini_comment = pcall(require, 'mini.comment')
if ok_mini_comment then require('mini.comment').setup() end
