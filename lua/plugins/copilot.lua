return {
  {
    'zbirenbaum/copilot.lua',
    -- lazy = true,
    event = 'InsertEnter',
    cmd = 'Copilot',
    build = ':Copilot auth',
    -- Turning this off to allow for cmp completion to handle
    -- config = function(_, _)
    --   vim.g.copilot_proxy_strict_ssl = false
    -- end,
    opts = {
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<CR>',
          refresh = 'gr',
          open = '<M-CR>',
        },
        layout = {
          position = 'right', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<C-CR>',
          -- accept = '<C-a>',
          accept_word = false,
          accept_line = false,
          next = '<C-h>',
          prev = '<A-h>',
          dismiss = '<C-]>',
        },
      },
      filetypes = {
        -- yaml = false,
        -- markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        -- ['.'] = false,
      },
      copilot_node_command = 'node', -- Node.js version must be > 18.x
      -- server_opts_overrides = {
      --   trace = 'verbose',
      --   -- The following is a workaround if nothing else works
      --   nodeModuleOpts = {
      --     NODE_TLS_REJECT_UNAUTHORIZED = '0',
      --   },
      -- },
    },
  },

  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   branch = 'main',
  --   -- selection = function(source)
  --   --   local selection = require 'CopilotChat.select'
  --   --   return selection.buffer(source) or selection.visual(source)
  --   -- end,
  --   keys = {
  --     { '<leader>cc', mode = { 'v', 'n' }, '<CMD>CopilotChatToggle<CR>', desc = 'CopilotChat - Toggle' },
  --     { '<leader>ce', mode = { 'v', 'n' }, '<CMD>CopilotChatExplain<CR>', desc = 'CopilotChat - Explain' },
  --     { '<leader>cf', mode = { 'v', 'n' }, '<CMD>CopilotChatFix<CR>', desc = 'CopilotChat - Fix' },
  --     -- { '<leader>ch', mode = { 'v', 'n' }, list_chat_history, desc = 'CopilotChat - History' },
  --     { '<leader>cm', mode = { 'v', 'n' }, '<CMD>CopilotChatModels<CR>', desc = 'CopilotChat - Models' },
  --     -- {
  --     --   '<leader>cq',
  --     --   function()
  --     --     local input = vim.fn.input 'Quick Chat: '
  --     --     if input ~= '' then
  --     --       require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
  --     --     end
  --     --   end,
  --     --   desc = 'CopilotChat - Quick chat',
  --     -- },
  --     -- {
  --     --   '<leader>co',
  --     --   function()
  --     --     local actions = require 'CopilotChat.actions'
  --     --     -- require('CopilotChat.integrations.snacks').pick(actions.prompt_actions())
  --     --     require('CopilotChat.integrations.snacks').pick(actions.prompt_actions())
  --     --     -- require('CopilotChat').select_prompt(actions.prompt_actions())
  --     --     -- require('CopilotChat').select_prompt(actions.prompt_actions())
  --     --   end,
  --     --   desc = 'CopilotChat - Prompt actions',
  --     -- },
  --     -- {
  --     --   '<leader>cg',
  --     --   function()
  --     --     local input = vim.fn.input 'Eggbert Chat:'
  --     --     if input ~= '' then
  --     --       require('CopilotChat').ask(input, {
  --     --         system_prompt = 'You are a helpful programming assistant. The user has a B.S. in Computer Science and is experienced with C#, but is new to the Godot Game Engine. They are creating their first game in Godot 4.3 using C#. The game is inspired by Undertale, with a combat system similar to The Binding of Isaac. Provide clear, practical guidance and explanations tailored to their background. ',
  --     --         selection = require('CopilotChat.select').buffer,
  --     --         context = '',
  --     --         sticky = {
  --     --           '#files',
  --     --         },
  --     --       })
  --     --     end
  --     --   end,
  --     --   desc = 'CopilotChat - Eggbert',
  --     -- },
  --   },
  --   dependencies = {
  --     { 'zbirenbaum/copilot.lua' }, -- or zbirenbaum/copilot.lua
  --     { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  --   },
  --   -- build = 'make tiktoken', -- Only on MacOS or Linux
  --   opts = {
  --     -- See Configuration section for options
  --     -- model = 'claude-3.7-sonnet', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
  --     -- model = 'gpt-4.1',
  --     window = {
  --       layout = 'vertical',
  --       -- height = 0.5,
  --     },
  --     highlight_headers = false,
  --     -- separator = '___',
  --     -- error_header = '> [!ERROR] Error',
  --     mappings = {
  --       reset = {
  --         normal = '<C-x>',
  --         insert = '<C-x>',
  --       },
  --     },
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
}
