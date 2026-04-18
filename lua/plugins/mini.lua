-- ============================================================================
-- Mini.nvim Configuration
-- Essential utility modules (ai, pairs, surround, comment)
-- ============================================================================
-- NOTE: mini.ai is configured to complement treesitter-textobjects:
--   - mini.ai: handles brackets (), {}, [], <>, quotes '', "", ``, tags <tag>
--   - treesitter-textobjects: handles semantic code (functions, classes, etc.)
-- They work together via mini.ai's treesitter integration!

vim.pack.add({ 'https://github.com/echasnovski/mini.nvim' })

-- Setup mini.ai with treesitter integration
-- This allows mini.ai to use treesitter as a fallback for semantic objects
local ok_mini_ai = pcall(require, 'mini.ai')
if ok_mini_ai then
  local mini_ai = require('mini.ai')
  mini_ai.setup({
    n_lines = 500,
    custom_textobjects = {
      -- Let mini.ai use treesitter for these (falls back to built-in when treesitter unavailable)
      f = mini_ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      c = mini_ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
      o = mini_ai.gen_spec.treesitter({
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      }),
    },
    -- Don't override treesitter-textobjects keymaps
    mappings = {
      -- Use mini.ai only for generic text objects (brackets, quotes, tags)
      -- treesitter-textobjects handles f, c, etc. via explicit keymaps
      around = 'a',
      inside = 'i',
      around_next = 'an',
      inside_next = 'in',
      around_last = 'al',
      inside_last = 'il',
      goto_left = 'g[',
      goto_right = 'g]',
    },
  })
end

local ok_mini_pairs = pcall(require, 'mini.pairs')
if ok_mini_pairs then require('mini.pairs').setup() end

local ok_mini_surround = pcall(require, 'mini.surround')
if ok_mini_surround then require('mini.surround').setup() end

local ok_mini_comment = pcall(require, 'mini.comment')
if ok_mini_comment then require('mini.comment').setup() end
