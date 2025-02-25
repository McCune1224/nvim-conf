return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    -- Turning this off to allow for cmp completion to handle
    event = 'InsertEnter',
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
          position = 'bottom', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<C-l>',
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
      -- server_opts_overrides = {},
    },
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    keys = {
      { '<leader>cc', mode = { 'v', 'n' }, ':CopilotChat<CR>', desc = 'CopilotChat - Open' },
      { '<leader>ce', mode = { 'v', 'n' }, ':CopilotChatExplain<CR>', desc = 'CopilotChat - Explain' },
      { '<leader>cf', mode = { 'v', 'n' }, ':CopilotChatFix<CR>', desc = 'CopilotChat - Fix' },
      {
        '<leader>cq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
      {
        '<leader>co',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.snacks').pick(actions.prompt_actions())
        end,
        desc = 'CopilotChat - Prompt actions',
      },
      -- {
      --   '<leader>cc',
      --   function()
      --     local actions = require 'CopilotChat.actions'
      --     require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
      --   end,
      --   desc = 'CopilotChat - Prompt actions',
      -- },
    },
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    -- build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      model = 'claude-3.7-sonnet', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
      window = {
        layout = 'horizontal',
        height = 0.4,
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
