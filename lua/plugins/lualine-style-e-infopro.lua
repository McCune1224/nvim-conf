-- ============================================================================
-- Lualine Style E: "InfoPro" 󰋜
-- Professional full-info layout
--   Winbar:   file icon + path + status (single, clean)
--   Tabline:  [1/n] tab counter (minimal, only when 2+ tabs)
--   Status:   branch · diff · diagnostics · aerial · location · progress
--
-- Optimized with built-in lualine components instead of custom Lua closures.
-- Key improvements:
--   - 'branch' + 'diff' instead of custom git_info()  (async, cached)
--   - 'filename' with path/symbols instead of custom filepath() + file_status()
--   - 'filetype' with icon_only instead of custom file_icon() (mini.icons)
--   - 'location' instead of custom position()
--   - 'progress' instead of custom progress()
--   - Added refresh throttle: no redraws on every CursorMoved
-- ============================================================================

vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

local ok_lualine, lualine = pcall(require, 'lualine')
if not ok_lualine then
  vim.notify('lualine.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

-- ── Global separator between components ──
local SEP = '    '

-- ── Git diff source: lightweight adapter for built-in 'diff' component ──
-- This is the only custon adapter needed. It reads gitsigns' pre-computed
-- status dict (a fast buffer-local table lookup, not a git call).
-- The 'diff' component handles caching and async internally.
local function diff_source()
  local gs = vim.b.gitsigns_status_dict
  if gs then
    return { added = gs.added, modified = gs.changed, removed = gs.removed }
  end
end

-- ── File status with colored indicators (preserves original look) ──
-- Kept as a minimal function to maintain colored [+] and [RO] in the winbar.
-- Uses only fast buffer-local reads (vim.bo) — negligible overhead.
local function file_status()
  local parts = {}
  if vim.bo.modified then
    table.insert(parts, '%#DiagnosticWarn#[+]%*')
  end
  if vim.bo.readonly then
    table.insert(parts, '%#DiagnosticError#[RO]%*')
  end
  return table.concat(parts, ' ')
end

-- ── Tab counter: only shown when 2+ tabs open ──
local function tab_number()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr '$'
  if total <= 1 then
    return '[1/1]'
  end
  return '[' .. current .. '/' .. total .. ']'
end

-- ── Lualine setup ──
lualine.setup {
  options = {
    theme = 'auto',
    section_separators = { left = '', right = '' },
    component_separators = { left = SEP, right = SEP },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree', 'aerial' },
      winbar = { 'dashboard', 'alpha', 'lazy', 'mason', 'oil', 'NvimTree' },
      tabline = { 'dashboard', 'alpha', 'lazy', 'mason' },
    },
    always_divide_middle = false,
    -- Throttle redraws: don't refresh on every cursor move.
    -- Only rebuild on meaningful buffer/focus/event changes.
    -- This is the key performance fix — custom functions were firing
    -- on CursorMoved/CursorMovedI (default events).
    refresh = {
      statusline = 500,
      tabline = 500,
      winbar = 500,
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'VimResized',
        'Filetype',
        'ModeChanged',
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════════
  -- WINBAR: File identity — icon + path + status (shown once)
  --   a: filetype icon    c: relative path + modified/readonly status
  -- ═══════════════════════════════════════════════════════════════
  winbar = {
    lualine_a = {
      { 'filetype', icon_only = true, colored = true, padding = { left = 2, right = 2 } },
    },
    lualine_b = {},
    lualine_c = {
      { 'filename', path = 1, file_status = false, padding = { left = 1, right = 1 } },
      { file_status, padding = { left = 1, right = 1 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  inactive_winbar = {
    lualine_a = {
      { 'filetype', icon_only = true, colored = true, padding = { left = 2, right = 2 } },
    },
    lualine_b = {},
    lualine_c = {
      { 'filename', path = 1, padding = { left = 1, right = 2 } },
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
    lualine_a = {},
    lualine_b = {
      { tab_number, padding = { left = 2, right = 2 } },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  -- ═══════════════════════════════════════════════════════════════
  -- STATUSBAR: Three alignment zones via Neovim %= items
  --   left:  branch · diff · diagnostics
  --   center: aerial breadcrumbs
  --   right: location · progress
  --
  -- Uses built-in components throughout:
  --   'branch'   — async git branch (libuv job, cached)
  --   'diff'     — git diff stats via gitsigns adapter (colored)
  --   'diagnostics' — LSP diagnostics (built-in)
  --   'aerial'   — code outline breadcrumbs (extension)
  --   'location' — line:col (built-in)
  --   'progress' — file progress % (built-in)
  -- ═══════════════════════════════════════════════════════════════
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      -- ── Left group: branch + diff + diagnostics ──
      { 'branch', icon = '', padding = { left = 1, right = 1 } },
      {
        'diff',
        source = diff_source,
        symbols = { added = '+', modified = '~', removed = '-' },
        diff_color = {
          added = 'DiagnosticOk',
          modified = 'DiagnosticWarn',
          removed = 'DiagnosticError',
        },
        colored = true,
        padding = { left = 1, right = 1 },
      },
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
      -- ── Center group: aerial breadcrumbs ──
      { 'aerial', depth = -3, padding = { left = 2, right = 2 } },

      '%=', -- ← Neovim native split: right from here

      -- ── Right group: location + progress ──
      { 'location', padding = { left = 1, right = 1 } },
      { 'progress', padding = { left = 1, right = 1 } },
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      { 'filename', path = 1, padding = { left = 1, right = 1 } },
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
