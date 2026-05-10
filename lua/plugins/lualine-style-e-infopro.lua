-- ============================================================================
-- Lualine Style E: "InfoPro" 󰋜
-- Professional full-info layout
--   Winbar:   file icon + path + status (single, clean)
--   Tabline:  [1/n] tab counter (minimal, only when 2+ tabs)
--   Status:   mode · git · diagnostics · aerial · position · count · progress
-- ============================================================================

vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

local ok_lualine, lualine = pcall(require, 'lualine')
if not ok_lualine then
  vim.notify('lualine.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

-- ── Global separator between components ──
-- Change this to any string you like, e.g. '│', '▎', '┊', '  ', ' ▏'
local SEP = '    '

-- ── Mode icons & text ──

local mode_icons = {
  normal = '■',
  insert = '■',
  visual = '■',
  v_line = '■',
  v_block = '■',
  replace = '■',
  command = '■',
  terminal = '■',
  inactive = '□',
}

local mode_text = {
  normal = 'N',
  insert = 'I',
  visual = 'V',
  v_line = 'VL',
  v_block = 'VB',
  replace = 'R',
  command = 'C',
  terminal = 'T',
}

-- ── Core components ──

local function filepath()
  local path = vim.fn.expand '%:.'
  return path == '' and '[no name]' or path
end

local function file_status()
  local status = {}
  if vim.bo.modified then
    table.insert(status, '%#DiagnosticWarn#[+]%*')
  end
  if vim.bo.readonly then
    table.insert(status, '%#DiagnosticError#[RO]%*')
  end
  return table.concat(status, ' ')
end

local function git_info()
  local branch = vim.b.gitsigns_head or vim.g.gitsigns_head
  if not branch or branch == '' then
    return ''
  end
  local status = vim.b.gitsigns_status_dict
  if not status then
    return ' ' .. branch
  end
  local parts = {}
  if status.added and status.added > 0 then
    table.insert(parts, '%#DiagnosticOk#+' .. status.added .. '%*')
  end
  if status.changed and status.changed > 0 then
    table.insert(parts, '%#DiagnosticWarn#~' .. status.changed .. '%*')
  end
  if status.removed and status.removed > 0 then
    table.insert(parts, '%#DiagnosticError#-' .. status.removed .. '%*')
  end
  return #parts > 0 and (' ' .. branch .. ' ' .. table.concat(parts, ' ')) or (' ' .. branch)
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  if not counts then
    return ''
  end
  local parts = {}
  local icons = { ' ', ' ', ' ', ' ' }
  for i = 1, 4 do
    local count = counts[i] or 0
    if count > 0 then
      table.insert(parts, icons[i] .. count)
    end
  end
  return table.concat(parts, '  ')
end

local function position()
  return vim.fn.line '.' .. ':' .. vim.fn.col '.'
end

local function progress()
  local line = vim.fn.line '.'
  local total = vim.fn.line '$'
  if total == 0 then
    return '0%'
  end
  return math.floor(line * 100 / total) .. '%%'
end

local function line_count()
  local total = vim.fn.line '$'
  if total == 0 then
    return ''
  end
  return total .. 'L'
end

-- Tab number (only shown in tabline when 2+ tabs open)
local function tab_number()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr '$'
  if total <= 1 then
    return ''
  end
  return '[' .. current .. '/' .. total .. ']'
end

-- Ensure mini.icons is initialized (no-op if already set up)
pcall(function()
  require('mini.icons').setup {}
end)

-- File icon from mini.icons (graceful fallback)
local function file_icon()
  local ok_icons, icons = pcall(require, 'mini.icons')
  if ok_icons then
    local icon, _ = icons.get('filetype', vim.bo.filetype)
    return icon or ''
  end
  return ''
end

local function get_mode_display()
  local mode = vim.fn.mode()
  local icon = mode_icons.normal
  local text = mode_text.normal
  if mode:match '^i' then
    icon = mode_icons.insert
    text = mode_text.insert
  elseif mode:match '^[vV]' then
    icon = mode_icons.visual
    text = mode_text.visual
  elseif mode == 'V' then
    icon = mode_icons.v_line
    text = mode_text.v_line
  elseif mode:match '^\22' then
    icon = mode_icons.v_block
    text = mode_text.v_block
  elseif mode:match '^[rR]' then
    icon = mode_icons.replace
    text = mode_text.replace
  elseif mode:match '^[cC]' then
    icon = mode_icons.command
    text = mode_text.command
  elseif mode == 't' then
    icon = mode_icons.terminal
    text = mode_text.terminal
  end
  return icon .. ' ' .. text
end

-- ── Helper: pull a color from the active colorscheme, with hardcoded fallback ──

local function hl_fg(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok and hl and hl.fg then return hl.fg end
  return fallback
end

-- ── Mode colors derived from colorscheme (no hardcoded hex values needed) ──

local function get_mode_color()
  local mode = vim.fn.mode()
  if mode:match '^i' then
    return { fg = hl_fg('DiffChange', '#e5c07b'), gui = 'bold' }
  elseif mode:match '^[vV]' then
    return { fg = hl_fg('DiagnosticInfo', '#61afef'), gui = 'bold' }
  elseif mode:match '^[rR]' then
    return { fg = hl_fg('DiffDelete', '#e06c75'), gui = 'bold' }
  elseif mode:match '^[cC]' then
    return { fg = hl_fg('Special', '#c678dd'), gui = 'bold' }
  elseif mode == 't' then
    return { fg = hl_fg('DiagnosticHint', '#56b6c2'), gui = 'bold' }
  else
    return { fg = hl_fg('DiffAdd', '#98c379'), gui = 'bold' }
  end
end

-- ── Lualine setup ──

lualine.setup {
  options = {
    theme = 'auto',
    -- Flat clean separators — professional, non-intrusive
    section_separators = { left = '', right = '' },
    -- Dots between components for subtle visual breathing room
    component_separators = { left = SEP, right = SEP },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree', 'aerial' },
      winbar = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree' },
      tabline = { 'dashboard', 'alpha', 'lazy', 'mason' },
    },
    always_divide_middle = false,
  },

  -- ═══════════════════════════════════════════════════════════════
  -- WINBAR: File identity — icon + path + status (shown once)
  --   a: file icon    c: path + modified/readonly status
  -- ═══════════════════════════════════════════════════════════════
  winbar = {
    lualine_a = {
      { file_icon, padding = { left = 2, right = 2 } },
    },
    lualine_b = {},
    lualine_c = {
      { filepath, padding = { left = 1, right = 1 } },
      { file_status, padding = { left = 1, right = 1 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  inactive_winbar = {
    lualine_a = {
      { file_icon, padding = { left = 2, right = 2 } },
    },
    lualine_b = {},
    lualine_c = {
      { filepath, padding = { left = 1, right = 2 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  -- ═══════════════════════════════════════════════════════════════
  -- TABLINE: Minimal tab counter — only visible when 2+ tabs open
  --   a: [current/total]    nothing else
  -- ═══════════════════════════════════════════════════════════════
  tabline = {
    lualine_a = {
      { tab_number, padding = { left = 2, right = 2 } },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  -- ═══════════════════════════════════════════════════════════════
  -- STATUSBAR: Three alignment zones via Neovim %= items
  --   left:  mode · git · diagnostics
  --   center: aerial breadcrumbs
  --   right: position · count · progress
  -- ═══════════════════════════════════════════════════════════════
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      -- ── Left group ──
      {
        get_mode_display,
        padding = { left = 1, right = 1 },
        color = get_mode_color,
      },
      { git_info, padding = { left = 1, right = 1 } },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        diagnostics_color = {
          error = 'DiagnosticError',
          warn = 'DiagnosticWarn',
          info = 'DiagnosticInfo',
          hint = 'DiagnosticHint',
        },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        colored = true,
        padding = { left = 1, right = 1 },
      },
      '%=', -- ← Neovim native split: center from here
      -- ── Center group (aerial) ──
      { 'aerial', depth = -3, padding = { left = 2, right = 2 } },

      '%=', -- ← Neovim native split: right from here

      -- ── Right group ──
      { position, padding = { left = 1, right = 1 } },
      { line_count, padding = { left = 1, right = 1 } },
      { progress, padding = { left = 1, right = 1 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
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

  extensions = {
    'lazy',
    'mason',
    'trouble',
    'quickfix',
    'aerial',
  },
}
