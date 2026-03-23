-- ============================================================================
-- nvim-dap Configuration
-- Debug Adapter Protocol
-- ============================================================================

-- Install plugins
vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
})

local ok_dap, dap = pcall(require, 'dap')
local ok_dv, dv = pcall(require, 'dap-view')

if not ok_dap or not ok_dv then
  return
end

-- Close dap-view with 'q'
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'dap-view', 'dap-view-term', 'dap-repl' },
  callback = function(evt)
    vim.keymap.set('n', 'q', '<C-w>q', { buffer = evt.buf })
  end,
})

-- Setup dap-view
dv.setup({
  winbar = {
    default_section = 'repl',
  },
  windows = {
    terminal = {
      hide = { 'go', 'godot' },
    },
  },
})

-- Godot adapter
dap.adapters.godot = {
  type = 'server',
  host = '127.0.0.1',
  port = 6006,
}

dap.configurations.gdscript = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch scene',
    project = '${workspaceFolder}',
    launch_scene = true,
  },
}

dap.configurations.cs = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Godot Launch',
    project = '${workspaceFolder}',
    launch_scene = true,
  },
}

-- Auto open/close dap-view
dap.listeners.before.attach['dap-view-config'] = function()
  dv.open()
end
dap.listeners.before.launch['dap-view-config'] = function()
  dv.open()
end
dap.listeners.before.event_terminated['dap-view-config'] = function()
  dv.close()
end
dap.listeners.before.event_exited['dap-view-config'] = function()
  dv.close()
end

-- Keymaps
local map = vim.keymap.set
map('n', '<leader>pu', '<cmd>DapViewToggle<CR>', { desc = '[P]rogram [U]I' })
map('n', '<leader>pc', function() dap.continue() end, { desc = '[P]rogram [C]ontinue' })
map('n', '<leader>po', function() dap.step_over() end, { desc = '[P]rogram [O]ver' })
map('n', '<leader>pi', function() dap.step_into() end, { desc = '[P]rogram [I]n' })
map('n', '<leader>pO', function() dap.step_out() end, { desc = '[P]rogram [O]ut' })
map('n', '<leader>pb', function() dap.toggle_breakpoint() end, { desc = '[P]rogram [B]reakpoint' })
map('n', '<leader>pp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = '[P]rogram [P]rint' })
map('n', '<leader>pr', '<cmd>DapToggleRepl<CR>', { desc = '[P]rogram [R]epl' })
