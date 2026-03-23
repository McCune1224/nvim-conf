-- ============================================================================
-- Harpoon Configuration
-- File marks with position tracking
-- ============================================================================

-- Install plugin and dependency
vim.pack.add({
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  'https://github.com/nvim-lua/plenary.nvim',
})

local harpoon = require('harpoon')

harpoon:setup({
  settings = {
    save_on_toggle = false,
  },
  default = {
    BufLeave = function()
      -- Do nothing to preserve cursor position
    end,
  },
})

-- Define the sign (Nerd Font glyph)
vim.cmd('sign define HarpoonMark text=󰛢 texthl=HarpoonSign')

-- Update harpoon signs in buffer
local function update_harpoon_signs()
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  if buf_name == '' then
    return
  end

  -- Clear old signs
  vim.cmd(string.format('sign unplace * buffer=%d', buf))

  local list = harpoon:list()
  if not list or not list.items then
    return
  end

  local buf_short = vim.fn.fnamemodify(buf_name, ':.')
  local buf_rel = vim.fn.fnamemodify(buf_name, ':~:.')

  for idx, item in ipairs(list.items) do
    local item_path = item.value or ''
    if item_path == '' then
      goto continue
    end

    local item_short = vim.fn.fnamemodify(item_path, ':.')
    local item_rel = vim.fn.fnamemodify(item_path, ':~:.')

    local matches = item_path == buf_name
      or item_path == buf_short
      or item_path == buf_rel
      or item_short == buf_short
      or item_rel == buf_rel

    local row = item.context and item.context.row

    if matches and row then
      vim.cmd(string.format('sign place %d line=%d name=HarpoonMark buffer=%d', idx, row, buf))
    end

    ::continue::
  end
end

-- Debug command (only available via :HarpoonSignsDebug)
vim.api.nvim_create_user_command('HarpoonSignsDebug', function()
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  vim.notify('Buffer: ' .. buf_name)
  vim.notify('buf_short: ' .. vim.fn.fnamemodify(buf_name, ':.'))
  vim.notify('buf_rel: ' .. vim.fn.fnamemodify(buf_name, ':~:.'))
  local list = harpoon:list()
  if list and list.items then
    for idx, item in ipairs(list.items) do
      local item_path = item.value or ''
      vim.notify(idx .. ': ' .. item_path)
      vim.notify('  item_short: ' .. vim.fn.fnamemodify(item_path, ':.'))
      vim.notify('  item_rel: ' .. vim.fn.fnamemodify(item_path, ':~:.'))
      vim.notify('  row: ' .. (item.context and item.context.row or 'nil'))
    end
  end
end, { desc = 'Debug harpoon signs' })

-- Autocmds for updating signs
vim.api.nvim_create_autocmd({ 'BufEnter', 'TabEnter', 'BufReadPost' }, {
  callback = update_harpoon_signs,
})

-- Listen for harpoon changes
harpoon:extend({
  name = 'HarpoonSigns',
  listen = function(_, event)
    if event == 'CHANGE' or event == 'ADD' or event == 'REMOVE' or event == 'REORDER' then
      vim.defer_fn(update_harpoon_signs, 100)
    end
  end,
})

-- ============================================================================
-- KEYMAPS
-- ============================================================================

local map = vim.keymap.set

map('n', '<leader>ha', function()
  harpoon:list():add()
  vim.defer_fn(update_harpoon_signs, 50)
end, { desc = '[H]arpoon [A]dd file' })

map('n', '<leader>hr', function()
  harpoon:list():remove()
  vim.defer_fn(update_harpoon_signs, 50)
end, { desc = '[H]arpoon [R]emove file' })

map('n', '<leader>ht', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
  vim.defer_fn(update_harpoon_signs, 50)
end, { desc = '[H]arpoon [T]oggle menu' })

-- Jump to harpoon marks 1-4
for i = 1, 4 do
  map('n', '<leader>h' .. i, function()
    local item = harpoon:list():get(i)
    if item then
      harpoon:list():select(i)
      -- Jump to saved position after file loads
      vim.defer_fn(function()
        if item.context and item.context.row then
          vim.api.nvim_win_set_cursor(0, { item.context.row, item.context.col or 0 })
        end
        update_harpoon_signs()
      end, 50)
    end
  end, { desc = '[H]arpoon jump to mark ' .. i })
end
