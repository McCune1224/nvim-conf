-- ============================================================================
-- Treesitter Configuration (nvim-treesitter main branch)
-- ============================================================================
-- NOTE: This is using the NEW main branch API, not the legacy master branch
-- See: https://github.com/nvim-treesitter/nvim-treesitter
--
-- Text Objects: Modern explicit API (2026)
-- Uses direct vim.keymap.set() for better which-key integration

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
}

-- Setup nvim-treesitter (optional, defaults work fine)
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath 'data' .. '/site',
}

-- ============================================================================
-- Enable Treesitter Features for All Filetypes
-- ============================================================================

-- Enable highlighting and indentation for any filetype that has a parser
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local ft = args.match
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    -- Check if parser exists for this language
    local ok = pcall(vim.treesitter.language.inspect, lang)
    if not ok then
      return
    end

    -- Enable syntax highlighting (built into Neovim)
    vim.treesitter.start()

    -- Enable treesitter-based indentation (provided by nvim-treesitter)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- ============================================================================
-- Parsers to Install (Stable Tier)
-- ============================================================================

-- Install all stable parsers on startup if not already installed
vim.defer_fn(function()
  local ts = require 'nvim-treesitter'
  local installed = ts.get_installed()

  if #installed == 0 then
    vim.notify('Installing all stable treesitter parsers...', vim.log.levels.INFO)
    ts.install 'stable'
  end
end, 100)

-- ============================================================================
-- Text Objects: Modern Explicit API
-- ============================================================================
-- Using vim.keymap.set() for full which-key integration and clarity

vim.defer_fn(function()
  local ok, tsto = pcall(require, 'nvim-treesitter-textobjects')
  if not ok then
    return
  end

  local select = require 'nvim-treesitter-textobjects.select'
  local move = require 'nvim-treesitter-textobjects.move'
  local swap = require 'nvim-treesitter-textobjects.swap'
  local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

  -- --------------------------------------------------------------------------
  -- SELECT: Visual/Operator Mode Text Objects
  -- --------------------------------------------------------------------------
  -- Format: v[modifier][target]
  --   modifier: i (inside), a (around)
  --   target: f (function), c (class), a (argument), l (loop), b (block), etc.

  local textobjects = {
    -- Functions
    { 'f', '@function.outer', '@function.inner', 'Function', 'f' },
    -- Classes/Types
    { 'c', '@class.outer', '@class.inner', 'Class', 'c' },
    -- Parameters/Arguments
    { 'a', '@parameter.outer', '@parameter.inner', 'Argument', 'a' },
    -- Loops
    { 'l', '@loop.outer', '@loop.inner', 'Loop', 'l' },
    -- Blocks (braces)
    { 'b', '@block.outer', '@block.inner', 'Block', 'b' },
    -- Conditionals (if/else)
    { '?', '@conditional.outer', '@conditional.inner', 'Conditional', '?' },
    -- Comments
    { 'g', '@comment.outer', '@comment.inner', 'Comment', 'g' },
    -- Assignments
    { '=', '@assignment.outer', '@assignment.inner', 'Assignment', '=' },
    -- Function Calls
    { 'C', '@call.outer', '@call.inner', 'Call', 'C' },
    -- Numbers
    { 'n', '@number.inner', nil, 'Number', 'n' },
    -- Return statements
    { 'r', '@return.outer', '@return.inner', 'Return', 'r' },
  }

  -- Create keymaps for each text object
  for _, obj in ipairs(textobjects) do
    local key = obj[1]
    local outer = obj[2]
    local inner = obj[3]
    local name = obj[4]
    local desc_key = obj[5]

    -- Around (outer)
    vim.keymap.set({ 'x', 'o' }, 'a' .. key, function()
      select.select_textobject(outer, 'textobjects')
    end, { desc = 'Around ' .. name })

    -- Inside (inner) - only if inner exists
    if inner then
      vim.keymap.set({ 'x', 'o' }, 'i' .. key, function()
        select.select_textobject(inner, 'textobjects')
      end, { desc = 'Inside ' .. name })
    end
  end

  -- --------------------------------------------------------------------------
  -- MOVE: Navigation Between Text Objects
  -- --------------------------------------------------------------------------
  -- Format: ]x (next start), ]X (next end), [x (prev start), [X (prev end)

  local movements = {
    -- Functions
    { 'f', '@function.outer', 'function' },
    { 'F', '@function.outer', 'function (end)', true },
    -- Classes
    { 'c', '@class.outer', 'class' },
    { 'C', '@class.outer', 'class (end)', true },
    -- Arguments/Parameters
    { 'a', '@parameter.outer', 'argument' },
    { 'A', '@parameter.outer', 'argument (end)', true },
    -- Loops
    { 'l', '@loop.*', 'loop' },
    { 'L', '@loop.*', 'loop (end)', true },
    -- Blocks
    { 'b', '@block.outer', 'block' },
    { 'B', '@block.outer', 'block (end)', true },
    -- Conditionals
    { '?', '@conditional.outer', 'conditional' },
    { '/', '@conditional.outer', 'conditional (end)', true },
    -- Comments
    { 'g', '@comment.outer', 'comment' },
    -- Scopes (from locals)
    { 's', '@local.scope', 'scope' },
    -- Folds
    { 'z', '@fold', 'fold' },
  }

  -- Create movement keymaps
  for _, mov in ipairs(movements) do
    local key = mov[1]
    local query = mov[2]
    local name = mov[3]
    local is_end = mov[4] or false

    local next_key = ']' .. key
    local prev_key = '[' .. key

    if is_end then
      -- Next end
      vim.keymap.set({ 'n', 'x', 'o' }, next_key, function()
        move.goto_next_end(query, 'textobjects')
      end, { desc = 'Next ' .. name })
      -- Previous end
      vim.keymap.set({ 'n', 'x', 'o' }, prev_key, function()
        move.goto_previous_end(query, 'textobjects')
      end, { desc = 'Previous ' .. name })
    else
      -- Next start
      vim.keymap.set({ 'n', 'x', 'o' }, next_key, function()
        move.goto_next_start(query, 'textobjects')
      end, { desc = 'Next ' .. name })
      -- Previous start
      vim.keymap.set({ 'n', 'x', 'o' }, prev_key, function()
        move.goto_previous_start(query, 'textobjects')
      end, { desc = 'Previous ' .. name })
    end
  end

  -- --------------------------------------------------------------------------
  -- SWAP: Swap Text Objects
  -- --------------------------------------------------------------------------
  -- <leader>s[n/p][target] - swap with next/previous

  -- Swap parameters/arguments
  vim.keymap.set('n', '<leader>sn', function()
    swap.swap_next '@parameter.inner'
  end, { desc = 'Swap with next parameter' })

  vim.keymap.set('n', '<leader>sp', function()
    swap.swap_previous '@parameter.inner'
  end, { desc = 'Swap with previous parameter' })

  -- Swap functions
  vim.keymap.set('n', '<leader>sf', function()
    swap.swap_next '@function.outer'
  end, { desc = 'Swap with next function' })

  vim.keymap.set('n', '<leader>sF', function()
    swap.swap_previous '@function.outer'
  end, { desc = 'Swap with previous function' })

  -- --------------------------------------------------------------------------
  -- REPEATABLE MOVEMENTS: ; and , support
  -- --------------------------------------------------------------------------
  -- Make movements repeatable like vim's f/F/t/T

  -- Repeat movement with ; and ,
  -- ; goes forward, , goes backward (vim-like behavior)
  vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
  vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

  -- Optional: Make builtin f, F, t, T also repeatable with ; and ,
  vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true, desc = 'Find next char' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true, desc = 'Find prev char' })
  vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true, desc = 'To next char' })
  vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true, desc = 'To prev char' })

  -- Notify that setup is complete
  vim.notify('Treesitter textobjects configured (modern API)', vim.log.levels.INFO)
end, 200)

-- ============================================================================
-- Commands
-- ============================================================================

-- Command to install all stable parsers
vim.api.nvim_create_user_command('TSInstallAll', function()
  local ts = require 'nvim-treesitter'
  vim.notify('Installing all stable parsers...', vim.log.levels.INFO)
  ts.install 'stable'
end, { desc = 'Install all stable treesitter parsers' })

-- Command to update all parsers
vim.api.nvim_create_user_command('TSUpdateAll', function()
  local ts = require 'nvim-treesitter'
  vim.notify('Updating all parsers...', vim.log.levels.INFO)
  ts.update()
end, { desc = 'Update all treesitter parsers' })

-- Command to check health
vim.api.nvim_create_user_command('TSHealth', function()
  vim.cmd 'checkhealth nvim-treesitter'
end, { desc = 'Check nvim-treesitter health' })
