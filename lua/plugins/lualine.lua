-- lualine.lua - Statusline

vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

local ok, lualine = pcall(require, 'lualine')
if not ok then
  return
end

local function filepath()
  local path = vim.fn.expand '%:.'
  if path == '' then
    return '[no name]'
  end

  local status = ''
  if vim.bo.modified then
    status = status .. '[+]'
  end
  if vim.bo.readonly then
    status = status .. '[RO]'
  end

  return status ~= '' and (path .. ' ' .. status) or path
end

local function git_info()
  local branch = vim.b.gitsigns_head or vim.g.gitsigns_head
  if not branch or branch == '' then
    return ''
  end

  local status = vim.b.gitsigns_status_dict
  if not status then
    return branch
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

  return #parts > 0 and (branch .. ' [' .. table.concat(parts, ' ') .. ']') or branch
end

local function tab_info()
  return require('config.tabs').get_statusline_text()
end

local function position()
  return vim.fn.line '.' .. ':' .. vim.fn.col '.'
end

lualine.setup {
  options = {
    component_separators = ' /// ',
    section_separators = ' ',
    globalstatus = true,
    disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'lazy', 'mason' } },
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { filepath, padding = 0 }, { 'branch', padding = 1 } },
    lualine_x = { { tab_info, padding = 0 }, { position, padding = 0 } },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = { filepath },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}
