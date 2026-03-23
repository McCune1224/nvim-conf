-- ============================================================================
-- Lualine Configuration
-- Sleek & Cool Statusline (no mode, no filetype, no lsp status)
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

local ok_lualine, lualine = pcall(require, 'lualine')
if not ok_lualine then
  return
end

-- Icons (Nerd Font glyphs, no emojis)
local icons = {
  git = '󰊢',
  modified = '●',
  readonly = '󰌾',
  error = '󰅚',
  warn = '󰀪',
  info = '󰋽',
  hint = '󰌶',
}

-- Filename with cool formatting
local function cool_filename()
  local filename = vim.fn.expand('%:t')
  if filename == '' then
    return '[No Name]'
  end
  
  local modified = vim.bo.modified and ' ' .. icons.modified or ''
  local readonly = vim.bo.readonly and ' ' .. icons.readonly or ''
  
  return filename .. modified .. readonly
end

lualine.setup({
  options = {
    theme = 'auto',
    component_separators = { left = '│', right = '│' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
  },
  sections = {
    lualine_a = {
      { cool_filename, padding = { left = 1, right = 1 } },
    },
    lualine_b = {
      { 'branch', icon = icons.git },
    },
    lualine_c = {},
    lualine_x = {
      { 'diagnostics', 
        symbols = { 
          error = icons.error .. ' ', 
          warn = icons.warn .. ' ', 
          info = icons.info .. ' ', 
          hint = icons.hint .. ' ' 
        },
      },
    },
    lualine_y = {},
    lualine_z = {
      { 'progress', padding = { left = 1, right = 1 } },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { { cool_filename } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})
