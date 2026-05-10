-- ============================================================================
-- Lualine Style I: "Zen" 　
-- Maximum breathing room — high padding, zero separators, floating elements
-- Section seps: none (just empty space between sections)
-- Component seps: none (spacing handled entirely by padding)
-- Feel: Spacious, minimal, airy, calm
-- ============================================================================

vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

local ok_lualine, lualine = pcall(require, 'lualine')
if not ok_lualine then
  vim.notify('lualine.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

-- Mode icons
local mode_icons = {
  normal = '■', insert = '■', visual = '■',
  v_line = '■', v_block = '■', replace = '■',
  command = '■', terminal = '■', inactive = '□',
}

-- ── Minimal core components (fewest possible for Zen) ──

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

-- Ultra-compact git: just branch icon + name
local function git_branch()
  local branch = vim.b.gitsigns_head or vim.g.gitsigns_head
  if not branch or branch == '' then return '' end
  return ' ' .. branch
end

-- Single total diagnostic number (or empty)
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

-- Just the mode icon, no text
local function get_mode_icon()
  local mode = vim.fn.mode()
  local icon = mode_icons.normal
  if mode:match('^i') then icon = mode_icons.insert
  elseif mode:match('^[vV]') then icon = mode_icons.visual
  elseif mode == 'V' then icon = mode_icons.v_line
  elseif mode:match('^\22') then icon = mode_icons.v_block
  elseif mode:match('^[rR]') then icon = mode_icons.replace
  elseif mode:match('^[cC]') then icon = mode_icons.command
  elseif mode == 't' then icon = mode_icons.terminal
  end
  return icon
end

lualine.setup({
  options = {
    theme = 'auto',
    -- NO separators at all — pure spacing creates the layout
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree', 'aerial' },
      winbar = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree' },
      tabline = { 'dashboard', 'alpha', 'lazy', 'mason' },
    },
    always_divide_middle = true,
  },

  -- ═══════════════════════════════════════════════════════════════
  -- BOTTOM BAR: Floating minimal
  --   a: mode (icon)    c: file    x: git+diag    z: position
  --   HEAVY padding everywhere — elements float in space
  -- ═══════════════════════════════════════════════════════════════
  sections = {
    lualine_a = {
      { get_mode_icon, padding = { left = 3, right = 3 } },
    },
    lualine_b = {},
    lualine_c = {
      { filepath, padding = { left = 3, right = 1 } },
      { file_status, padding = { left = 3, right = 3 } },
    },
    lualine_x = {
      { git_branch, padding = { left = 3, right = 1 } },
    },
    lualine_y = {
      { diag_total, padding = { left = 3, right = 3 } },
    },
    lualine_z = {
      { position, padding = { left = 3, right = 1 } },
      { progress, padding = { left = 3, right = 3 } },
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { filepath, padding = { left = 3, right = 3 } },
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
