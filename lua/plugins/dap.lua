-- Your nvim-dap config
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'igorlfs/nvim-dap-view', opts = { windows = {
        terminal = {
          hide = { 'go', 'godot' },
        },
      } } },
      ...,
    },
    config = function()
      local dap = require 'dap'
      local dv = require 'dap-view'
      -- Godot
      --
      dap.adapters.godot = {
        type = 'server',
        host = '127.0.0.1',
        port = 6006,
      }
      dap.configurations.gdscript = {
        {
          type = 'godot',
          request = 'launch',
          hasl,
          dkghsadklgs,
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

      -- -- C#
      dap.adapters.coreclr = {
        type = 'executable',
        command = '~/.config/nvim/lua/alexm/plugins/netcoredbg/netcoredbg',
        args = { '--interpreter=vscode' },
        options = {
          detached = false,
        },
      }
      -- dap.configurations.cs = {
      --   {
      --     name = 'Launch file',
      --     type = 'coreclr',
      --     request = 'launch',
      --     program = function()
      --       local function find_debug_dir(start_path)
      --         local sep = vim.fn.has 'win32' == 1 and '\\' or '/'
      --         local debug_pattern = sep .. 'bin' .. sep .. 'Debug'
      --
      --         -- Use vim.fn.finddir to search for Debug directory
      --         local debug_dir = vim.fn.finddir('Debug', start_path .. '/**/bin')
      --
      --         if debug_dir ~= '' then
      --           local full_path = vim.fn.fnamemodify(debug_dir, ':p')
      --           -- Ensure path ends with separator
      --           return full_path:sub(-1) ~= sep and full_path .. sep or full_path
      --         end
      --         return nil
      --       end
      --
      --       local cwd = vim.fn.getcwd()
      --       local debug_path = find_debug_dir(cwd)
      --
      --       if debug_path then
      --         return debug_path
      --       else
      --         -- Fall back to original prompt if automatic detection fails
      --         if vim.fn.has 'win32' == 1 then
      --           return vim.fn.input('Path to dll', cwd .. '\\bin\\Debug\\', 'file')
      --         else
      --           return vim.fn.input('Path to dll', cwd .. '/bin/Debug/', 'file')
      --         end
      --       end
      --     end,
      --   },
      -- }

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

      -- Keybindings
      -- { '<leader>au', function() require('dapui').toggle {} end, desc = '[A]dapter [U]I', },
      -- { '<leader>av', function() require('dapui').eval() end, desc = '[A]dapter e[V]al', mode = { 'n', 'v' }, },
      vim.api.nvim_set_keymap('n', '<leader>au', '<cmd>DapViewToggle<CR>', { noremap = true, silent = true, desc = '[A]dapter [U]I' })
      -- vim.api.nvim_set_keymap('n', '<leader>av', '<cmd>lua require"dapui".eval()<CR>', { noremap = true, silent = true, desc = '[A]dapter e[V]al' })
      vim.api.nvim_set_keymap('n', '<leader>ac', '<cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true, desc = '[A]dapter [C]ontinue' })
      vim.api.nvim_set_keymap('n', '<leader>ao', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true, desc = '[A]dapater [O]ver' })
      vim.api.nvim_set_keymap('n', '<leader>ai', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true, desc = '[A]dapter [O]ut' })
      vim.api.nvim_set_keymap('n', '<leader>aO', '<cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ab',
        '<cmd>lua require"dap".toggle_breakpoint()<CR>',
        { noremap = true, silent = true, desc = '[A]dapter [B]reakpoint' }
      )
      -- vim.api.nvim_set_keymap(
      --   'n',
      --   '<leader>B',
      --   '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      --   { noremap = true, silent = true }
      -- )
      vim.api.nvim_set_keymap(
        'n',
        '<leader>ap',
        '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
        { noremap = true, silent = true, desc = '[A]dapter [P]rint' }
      )
      -- vim.api.nvim_set_keymap('n', '<leader>ar', '<cmd>lua require"dap".repl.open()<CR>', { noremap = true, silent = true, desc = '[A]dapter [R]epl' })
      vim.api.nvim_set_keymap('n', '<leader>ar', '<cmd>DapToggleRepl<CR>', { noremap = true, silent = true, desc = '[A]dapter [R]epl' })
      -- vim.api.nvim_set_keymap('n', '<leader>al', '<cmd>lua require"dap".run_last()<CR>', { noremap = true, silent = true, '[A]dapter [L]ast' })
    end,
  },
}
