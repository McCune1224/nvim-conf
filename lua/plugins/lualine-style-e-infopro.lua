-- ============================================================================
-- Lualine Style E: "InfoPro" 󰋜
-- Professional full-info layout: time, encoding, LSP, diagnostics, context
-- Winbar shows current function/symbol at all times
-- Statusline shows everything at a glance
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

local mode_text = {
  normal = 'N', insert = 'I', visual = 'V',
  v_line = 'VL', v_block = 'VB', replace = 'R',
  command = 'C', terminal = 'T',
}

-- Compact mode text (1-2 chars for pro minimal feel)

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

local function git_info()
  local branch = vim.b.gitsigns_head or vim.g.gitsigns_head
  if not branch or branch == '' then return '' end
  local status = vim.b.gitsigns_status_dict
  if not status then return ' ' .. branch end
  local parts = {}
  if status.added and status.added > 0 then table.insert(parts, '+' .. status.added) end
  if status.changed and status.changed > 0 then table.insert(parts, '~' .. status.changed) end
  if status.removed and status.removed > 0 then table.insert(parts, '-' .. status.removed) end
  local icon = ' '
  return #parts > 0 and (icon .. branch .. ' ' .. table.concat(parts, ' ')) or (icon .. branch)
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  if not counts then return '' end
  local parts = {}
  local icons = { '', '', '', '' }
  for i = 1, 4 do
    local count = counts[i] or 0
    if count > 0 then table.insert(parts, icons[i] .. count) end
  end
  return table.concat(parts, '  ')
end

local function tab_number()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  if total <= 1 then return '' end
  return '[' .. current .. '/' .. total .. ']'
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

local function get_mode_display()
  local mode = vim.fn.mode()
  local icon = mode_icons.normal
  local text = mode_text.normal
  if mode:match('^i') then icon = mode_icons.insert; text = mode_text.insert
  elseif mode:match('^[vV]') then icon = mode_icons.visual; text = mode_text.visual
  elseif mode == 'V' then icon = mode_icons.v_line; text = mode_text.v_line
  elseif mode:match('^\22') then icon = mode_icons.v_block; text = mode_text.v_block
  elseif mode:match('^[rR]') then icon = mode_icons.replace; text = mode_text.replace
  elseif mode:match('^[cC]') then icon = mode_icons.command; text = mode_text.command
  elseif mode == 't' then icon = mode_icons.terminal; text = mode_text.terminal
  end
  return icon .. text
end

-- ── Per-buffer / extra components ──

-- Per-buffer: encoding + format
local function encoding_info()
  local enc = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
  local fmt = vim.bo.fileformat
  return enc .. ' ' .. fmt
end

-- Current time (subtle, for reference)
local function clock()
  return os.date '%H:%M'
end

-- Lines in file
local function line_count()
  local total = vim.fn.line('$')
  if total == 0 then return '' end
  return total .. 'L'
end

lualine.setup({
  options = {
    theme = 'auto',
    -- Rounded block separators for a professional flow
    section_separators = { left = '', right = '' },
    component_separators = { left = ' · ', right = ' · ' },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree', 'aerial' },
      winbar = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree' },
      tabline = { 'dashboard', 'alpha', 'lazy', 'mason' },
    },
    always_divide_middle = true,
  },

  -- ═══════════════════════════════════════════════════════════════
  -- WINBAR: File path (always in view)
  -- ═══════════════════════════════════════════════════════════════
  winbar = {
    lualine_a = {
      { filepath, padding = { left = 1, right = 1 } },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      { filepath, padding = { left = 1, right = 1 } },
    },
  },

  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  -- ═══════════════════════════════════════════════════════════════
  -- BOTTOM BAR: Full info at a glance
  --   a: mode    b: git    c: diagnostics    x: aerial    y: encoding+pos    z: time+progress
  -- ═══════════════════════════════════════════════════════════════
  sections = {
    lualine_a = {
      { get_mode_display, padding = { left = 1, right = 1 } },
    },
    lualine_b = {
      { git_info, padding = { left = 1, right = 1 } },
    },
    lualine_c = {
      { diagnostics, padding = { left = 1, right = 1 } },
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
    lualine_y = {
      { encoding_info, padding = { left = 1, right = 1 } },
      { position, padding = { left = 1, right = 1 } },
      { progress, padding = { left = 1, right = 1 } },
    },
    lualine_z = {
      { clock, padding = { left = 1, right = 1 } },
      { line_count, padding = { left = 1, right = 1 } },
      { tab_number, padding = { left = 1, right = 1 } },
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { filepath, padding = { left = 1, right = 1 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  tabline = {},

  extensions = {
    'lazy', 'mason', 'trouble', 'quickfix', 'aerial',
  },
})
