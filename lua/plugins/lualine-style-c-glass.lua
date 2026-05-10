-- ============================================================================
-- Lualine Style C: "Glass" ✦
-- TRUE terminal transparency: ALL backgrounds set to NONE
-- Minimal components, maximum breathing room
-- Re-applies transparency after colorscheme changes
-- ============================================================================

vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

local ok_lualine, lualine = pcall(require, 'lualine')
if not ok_lualine then
  vim.notify('lualine.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

-- Mode icons (just icon, no text — minimal)
local mode_icons = {
  normal = '■', insert = '■', visual = '■',
  v_line = '■', v_block = '■', replace = '■',
  command = '■', terminal = '■', inactive = '□',
}

-- ── Shared core components ──

local function filepath()
  local path = vim.fn.expand('%:.')
  return path == '' and '[no name]' or path
end

local function file_status()
  local status = {}
  if vim.bo.modified then table.insert(status, '[+]') end
  if vim.bo.readonly then table.insert(status, '[RO]') end
  return table.concat(status, ' ')
end

-- Compact git: just branch name + total diff count
local function git_compact()
  local branch = vim.b.gitsigns_head or vim.g.gitsigns_head
  if not branch or branch == '' then return '' end
  local status = vim.b.gitsigns_status_dict
  local diff = ''
  if status then
    local total = (status.added or 0) + (status.changed or 0) + (status.removed or 0)
    if total > 0 then diff = ' ' .. total end
  end
  return ' ' .. branch .. diff
end

-- Total diagnostic count (just a number)
local function diag_total()
  local counts = vim.diagnostic.count(0)
  if not counts then return '' end
  local total = 0
  for _, count in ipairs(counts) do
    total = total + (count or 0)
  end
  return total > 0 and tostring(total) or ''
end

local function position()
  return vim.fn.line('.') .. ':' .. vim.fn.col('.')
end

local function progress()
  local line = vim.fn.line('.')
  local total = vim.fn.line('$')
  if total == 0 then return '0%' end
  return math.floor(line * 100 / total) .. '%%'
end

-- ── Full transparency setup ──
-- This sets ALL Lualine highlight group backgrounds to NONE
-- and re-applies after every ColorScheme change

local function make_lualine_transparent()
  -- List all known Lualine highlight groups across all modes
  local modes = { 'Normal', 'Insert', 'Visual', 'Replace', 'Command', 'Terminal', 'Inactive' }
  local suffixes = { '', 'Separator' }

  for _, mode in ipairs(modes) do
    for _, suffix in ipairs(suffixes) do
      local group = 'Lualine' .. mode .. suffix
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
      if ok and hl then
        vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = 'NONE', bold = hl.bold, italic = hl.italic })
      end
    end
  end

  -- Also handle section-specific groups (LualineNormalA, LualineNormalB, etc.)
  local sections = { 'A', 'B', 'C', 'X', 'Y', 'Z' }
  for _, mode in ipairs(modes) do
    for _, section in ipairs(sections) do
      local group = 'Lualine' .. mode .. section
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
      if ok and hl then
        vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = 'NONE', bold = hl.bold, italic = hl.italic })
      end
    end
  end
end

-- Apply immediately
make_lualine_transparent()

-- Re-apply whenever colorscheme changes
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('LualineGlassTransparent', { clear = true }),
  pattern = '*',
  callback = make_lualine_transparent,
})

lualine.setup({
  options = {
    theme = 'auto',
    -- No separators at all — just spacing creates the layout
    section_separators = '',
    component_separators = '',
    globalstatus = true,
    disabled_filetypes = {
      statusline = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree', 'aerial' },
      winbar = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree' },
      tabline = { 'dashboard', 'alpha', 'lazy', 'mason' },
    },
    always_divide_middle = true,
  },

  -- ═══════════════════════════════════════════════════════════════
  -- BOTTOM BAR: Minimal — just what you need
  --   a: mode (icon only)    b: git    c: file    x: aerial    z: pos
  -- ═══════════════════════════════════════════════════════════════
  sections = {
    lualine_a = {
      { function() return mode_icons[vim.fn.mode():match('^i') and 'insert'
        or vim.fn.mode():match('^[vV]') and 'visual'
        or vim.fn.mode():match('^[rR]') and 'replace'
        or vim.fn.mode():match('^[cC]') and 'command'
        or vim.fn.mode() == 't' and 'terminal'
        or 'normal' end,
        padding = { left = 2, right = 2 },
      },
    },
    lualine_b = {
      { git_compact, padding = { left = 2, right = 2 } },
    },
    lualine_c = {
      { filepath, padding = { left = 2, right = 1 } },
      { file_status, padding = { left = 1, right = 2 } },
    },
    lualine_x = {
      {
        'aerial',
        sep = ' ▸ ',
        sep_icon = '',
        sep_highlight = 'LualineSeparator',
        dense = false,
        dense_sep = ' ▸ ',
        depth = nil,
        depth_gap = 0,
        padding = { left = 2, right = 2 },
      },
    },
    lualine_y = {},
    lualine_z = {
      { diag_total, padding = { left = 2, right = 1 } },
      { position, padding = { left = 1, right = 1 } },
      { progress, padding = { left = 1, right = 2 } },
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { filepath, padding = { left = 2, right = 2 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {
    'lazy', 'mason', 'trouble', 'quickfix', 'aerial',
  },
})
