-- ============================================================================
-- TAB CONFIGURATION
-- Auto-name tabs based on active buffer
-- ============================================================================

local M = {}

-- Generate tab name from buffer
local function get_buffer_name(buf)
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
  local bufname = vim.api.nvim_buf_get_name(buf)
  
  -- Special buffer types
  if buftype == 'terminal' then
    return '[term]'
  elseif buftype == 'help' then
    local help_topic = vim.fn.fnamemodify(bufname, ':t:r')
    return '[help: ' .. help_topic .. ']'
  elseif buftype == 'quickfix' then
    return '[qf]'
  elseif buftype == 'prompt' then
    return '[prompt]'
  end
  
  -- Regular buffer
  if bufname == '' then
    return '[scratch]'
  end
  
  -- Return just filename
  return vim.fn.fnamemodify(bufname, ':t')
end

-- Update tab name based on current buffer
function M.update_tab_name()
  local tab = vim.api.nvim_get_current_tabpage()
  local win = vim.api.nvim_tabpage_get_win(tab)
  local buf = vim.api.nvim_win_get_buf(win)

  -- Don't overwrite manual names
  local ok = pcall(vim.api.nvim_tabpage_get_var, tab, 'tabname')
  if ok then
    return
  end

  local name = get_buffer_name(buf)
  vim.api.nvim_tabpage_set_var(tab, 'auto_tabname', name)

  -- Trigger redraw (defer to avoid startup issues)
  vim.schedule(function()
    vim.cmd('redrawtabline')
  end)
end

-- Get display name for a tab
function M.get_tab_name(tabnr)
  local tabs = vim.api.nvim_list_tabpages()
  local tab = tabs[tabnr]
  if not tab then
    return '?'
  end
  
  -- Check custom name first
  local ok, name = pcall(vim.api.nvim_tabpage_get_var, tab, 'tabname')
  if ok and name and name ~= '' then
    return name
  end
  
  -- Check auto name
  ok, name = pcall(vim.api.nvim_tabpage_get_var, tab, 'auto_tabname')
  if ok and name and name ~= '' then
    return name
  end
  
  -- Fallback: get current buffer name
  local win = vim.api.nvim_tabpage_get_win(tab)
  local buf = vim.api.nvim_win_get_buf(win)
  return get_buffer_name(buf)
end

-- Format for statusline (current tab only)
function M.get_statusline_text()
  local current = vim.fn.tabpagenr()
  local total = vim.fn.tabpagenr('$')
  
  if total <= 1 then
    return ''
  end
  
  local name = M.get_tab_name(current)
  return current .. '/' .. total .. ' ' .. name
end

-- Format all tabs for display
function M.get_all_tabs_text()
  local tabs = vim.api.nvim_list_tabpages()
  local current = vim.fn.tabpagenr()
  local total = #tabs
  
  if total <= 1 then
    return ''
  end
  
  local parts = {}
  for nr, _ in ipairs(tabs) do
    local name = M.get_tab_name(nr)
    -- Truncate long names
    if #name > 15 then
      name = string.sub(name, 1, 12) .. '...'
    end
    
    if nr == current then
      table.insert(parts, '[' .. nr .. ':' .. name .. ']')
    else
      table.insert(parts, nr .. ':' .. name)
    end
  end
  
  return table.concat(parts, ' ')
end

-- Setup autocmds
function M.setup()
  local group = vim.api.nvim_create_augroup('TabAutoName', { clear = true })
  
  -- Update tab name when entering tabs, buffers, or windows
  vim.api.nvim_create_autocmd({ 'TabEnter', 'BufEnter', 'WinEnter' }, {
    group = group,
    callback = function()
      M.update_tab_name()
    end,
  })
  
  -- Manual tab naming commands
  vim.api.nvim_create_user_command('TabName', function(args)
    local name = args.args
    local tab = vim.api.nvim_get_current_tabpage()
    if name and name ~= '' then
      vim.api.nvim_tabpage_set_var(tab, 'tabname', name)
    else
      pcall(vim.api.nvim_tabpage_del_var, tab, 'tabname')
    end
    vim.schedule(function()
      vim.cmd('redrawtabline')
    end)
  end, { nargs = '?', desc = 'Set custom tab name (empty to clear)' })

  vim.api.nvim_create_user_command('TabNameClear', function()
    local tab = vim.api.nvim_get_current_tabpage()
    pcall(vim.api.nvim_tabpage_del_var, tab, 'tabname')
    vim.schedule(function()
      vim.cmd('redrawtabline')
    end)
  end, { desc = 'Clear custom tab name' })
end

return M
