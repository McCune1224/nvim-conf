-- ============================================================================
-- Lualine Configuration - Ember Theme
-- Rustic, wooden & blocky aesthetic matching ironbar styling
-- Top: Aerial breadcrumbs | Bottom: Status + Tabs
-- Colors handled by colorscheme
-- ============================================================================

vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

local ok, lualine = pcall(require, 'lualine')
if not ok then
  return
end

-- Mode icons - filled squares for active, empty for inactive
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

-- Custom components
local function filepath()
  local path = vim.fn.expand('%:.')
  if path == '' then
    return '[no name]'
  end
  return path
end

local function file_status()
  local status = {}
  if vim.bo.modified then
    table.insert(status, '[+]')
  end
  if vim.bo.readonly then
    table.insert(status, '[RO]')
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
    table.insert(parts, '+' .. status.added)
  end
  if status.changed and status.changed > 0 then
    table.insert(parts, '~' .. status.changed)
  end
  if status.removed and status.removed > 0 then
    table.insert(parts, '-' .. status.removed)
  end

  local icon = ' '
  return #parts > 0 and (icon .. branch .. ' ' .. table.concat(parts, ' ')) or (icon .. branch)
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  if not counts then
    return ''
  end

  local parts = {}
  -- Consistent geometric shapes for Lilex Nerd Font
  -- All from same icon family for uniform sizing
  local icons = { '', '', '', '' }

  for i = 1, 4 do
    local count = counts[i] or 0
    if count > 0 then
      table.insert(parts, icons[i] .. count)
    end
  end

  return table.concat(parts, '  ')
end

local function tab_number()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  if total <= 1 then
    return ''
  end
  return '[' .. current .. '/' .. total .. ']'
end

local function position()
  return vim.fn.line('.') .. ':' .. vim.fn.col('.')
end

local function progress()
  local line = vim.fn.line('.')
  local total = vim.fn.line('$')
  if total == 0 then
    return '0%'
  end
  return math.floor(line * 100 / total) .. '%%'
end

-- Get mode icon
local function get_mode_icon()
  local mode = vim.fn.mode()
  local icon = mode_icons.normal

  if mode:match('^i') then
    icon = mode_icons.insert
  elseif mode:match('^[vV]') then
    icon = mode_icons.visual
  elseif mode == 'V' then
    icon = mode_icons.v_line
  elseif mode:match('^\22') then
    icon = mode_icons.v_block
  elseif mode:match('^[rR]') then
    icon = mode_icons.replace
  elseif mode:match('^[cC]') then
    icon = mode_icons.command
  elseif mode == 't' then
    icon = mode_icons.terminal
  end

  return icon
end

lualine.setup({
  options = {
    theme = 'auto', -- Let colorscheme handle colors
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { 'dashboard', 'alpha', 'lazy', 'mason', 'neo-tree', 'NvimTree', 'aerial' },
      winbar = { 'dashboard', 'alpha', 'lazy', 'mason', 'neo-tree', 'NvimTree' },
      tabline = { 'dashboard', 'alpha', 'lazy', 'mason' },
    },
    always_divide_middle = true,
  },

  -- BOTTOM BAR: Mode | Git | File | Diagnostics | Position | Tabs
  sections = {
    lualine_a = {
      {
        function() return get_mode_icon() end,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_b = {
      { git_info, padding = { left = 1, right = 1 } },
    },
    lualine_c = {
      {
        filepath,
        padding = { left = 1, right = 0 },
      },
      {
        file_status,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_x = {},
    lualine_y = {
      {
        diagnostics,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_z = {
      {
        position,
        padding = { left = 1, right = 0 },
      },
      {
        progress,
        padding = { left = 1, right = 1 },
      },
      {
        tab_number,
        padding = { left = 1, right = 1 },
      },
    },
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        filepath,
        padding = { left = 1, right = 1 },
      },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  -- TOP BAR: Aerial breadcrumbs with blocky separator
  tabline = {
    lualine_a = {
      {
        'aerial',
        sep = ' ▶ ',
        sep_icon = '',
        sep_highlight = 'LualineSeparator',
        dense = false,
        dense_sep = ' ▶ ',
        depth = nil,
        depth_gap = 0,
        padding = { left = 2, right = 1 },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  winbar = {},
  inactive_winbar = {},
  extensions = {
    'neo-tree',
    'lazy',
    'mason',
    'trouble',
    'quickfix',
    'aerial',
  },
})
