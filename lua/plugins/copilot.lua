local CHAT_HISTORY_DIR = vim.fn.stdpath 'data' .. '/copilot-chats'

local function delete_old_chat_files()
  local scandir = require 'plenary.scandir'

  local files = scandir.scan_dir(CHAT_HISTORY_DIR, {
    search_pattern = '%.json$',
    depth = 1,
  })

  local current_time = os.time()
  local one_month_ago = current_time - (30 * 24 * 60 * 60) -- 30 days in seconds
  local deleted_count = 0

  for _, file in ipairs(files) do
    local mtime = vim.fn.getftime(file)

    if mtime < one_month_ago then
      local success, err = os.remove(file)
      if success then
        deleted_count = deleted_count + 1
      else
        vim.notify('Failed to delete old chat file: ' .. err, vim.log.levels.WARN)
      end
    end
  end

  if deleted_count > 0 then
    vim.notify('Deleted ' .. deleted_count .. ' old chat files', vim.log.levels.INFO)
  end
end

--- Lists and displays Copilot chat history in a picker UI
---
--- This function:
--- 1. Cleans up old chat history files (older than 30 days)
--- 2. Scans for JSON chat history files
--- 3. Displays them in a picker with:
---    - Preview of chat contents
---    - Ability to load previous chats (Enter key)
---    - Ability to delete chat files ('dd' keybinding)
--- 4. Sorts files by date (newest first)
local function list_chat_history()
  local snacks = require 'snacks'
  local chat = require 'CopilotChat'
  local scandir = require 'plenary.scandir'
  -- Delete old chat files first
  delete_old_chat_files()

  local files = scandir.scan_dir(CHAT_HISTORY_DIR, {
    search_pattern = '%.json$',
    depth = 1,
  })

  if #files == 0 then
    vim.notify('No chat history found', vim.log.levels.INFO)
    return
  end

  local items = {}
  for i, item in ipairs(files) do
    -- Extract basename from file's full path without extension
    local filename = item:match '^.+[/\\](.+)$' or item
    local basename = filename:match '^(.+)%.[^%.]*$' or filename

    table.insert(items, {
      idx = i,
      file = item,
      basename = basename,
      text = basename,
    })
  end

  table.sort(items, function(a, b)
    return a.file > b.file
  end)

  -- Check if we have any valid items
  if #items == 0 then
    vim.notify('No valid chat history files found', vim.log.levels.INFO)
    return
  end

  snacks.picker {
    actions = {
      delete_history_file = function(picker, item)
        if not item or not item.file then
          vim.notify('No file selected', vim.log.levels.WARN)
          return
        end

        -- Confirm deletion
        vim.ui.select({ 'Yes', 'No' }, { prompt = 'Delete ' .. vim.fn.fnamemodify(item.file, ':t') .. '?' }, function(choice)
          if choice == 'Yes' then
            -- Delete the file
            local success, err = os.remove(item.file)
            if success then
              vim.notify('Deleted: ' .. item.file, vim.log.levels.INFO)
              -- Refresh the picker to show updated list
              picker:close()
              vim.schedule(function()
                list_chat_history()
              end)
            else
              vim.notify('Failed to delete: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
            end
          end
        end)
      end,
    },
    confirm = function(picker, item)
      picker:close()

      -- Verify file exists before loading
      if not vim.fn.filereadable(item.file) then
        vim.notify('Chat history file not found: ' .. item.file, vim.log.levels.ERROR)
        return
      end

      vim.g.copilot_chat_title = item.basename
      -- vim.cmd 'WindowToggleMaximize forceOpen'
      -- vim.cmd 'split'

      chat.open()
      chat.load(item.basename)
    end,
    items = items,
    format = function(item)
      local prompt = item.file:match '[0-9]*_[0-9]*_(.+)%.json$'
      local display = ' ' .. prompt:gsub('[-_]', ' '):gsub('^%l', string.upper)

      local mtime = vim.fn.getftime(item.file)
      local date = vim.fn.reltime(mtime)

      return {
        { string.format('%-5s', date), 'SnacksPickerLabel' },
        { display },
      }
    end,
    preview = function(ctx)
      local file = io.open(ctx.item.file, 'r')
      if not file then
        ctx.preview:set_lines { 'Unable to read file' }
        return
      end

      local content = file:read '*a'
      file:close()

      local ok, messages = pcall(vim.json.decode, content, {
        luanil = {
          object = true,
          array = true,
        },
      })

      if not ok then
        ctx.preview:set_lines { 'vim.fn.json_decode error' }
        return
      end

      local config = chat.config
      local preview = {}
      for _, message in ipairs(messages or {}) do
        local header = message.role == 'user' and config.question_header or config.answer_header
        table.insert(preview, header .. config.separator .. '\n')
        table.insert(preview, message.content .. '\n')
      end

      ctx.preview:highlight { ft = 'copilot-chat' }
      ctx.preview:set_lines(preview)
    end,
    sort = {
      fields = { 'text:desc' },
    },
    title = 'Copilot Chat History',
    win = {
      input = {
        keys = {
          ['dd'] = 'delete_history_file', -- Use our custom action
        },
      },
    },
  }
end

local function read_prompt_file(basename)
  local config_dir = tostring(vim.fn.stdpath 'config')
  local prompt_dir = vim.fs.joinpath(config_dir, 'prompts')
  local file_path = vim.fs.joinpath(prompt_dir, string.format('%s.md', string.lower(basename)))
  if not vim.fn.filereadable(file_path) then
    return ''
  end

  return table.concat(vim.fn.readfile(file_path), '\n')
end

local function save_chat(response)
  local chat = require 'CopilotChat'

  if vim.g.copilot_chat_title then
    chat.save(vim.g.copilot_chat_title)
    return
  end

  -- use AI to generate prompt title based on first AI response to user question
  local prompt = read_prompt_file 'chattitle'
  chat.ask(vim.trim(prompt:format(response)), {
    callback = function(gen_response)
      -- Generate timestamp in format YYYYMMDD_HHMMSS
      local timestamp = os.date '%Y%m%d_%H%M%S'
      vim.g.copilot_chat_title = timestamp .. '_' .. vim.trim(gen_response)
      chat.save(vim.g.copilot_chat_title)
    end,
    headless = true, -- disable updating chat buffer and history with this question
    -- model = vim.fn.getenv 'COPILOT_MODEL_CHEAP',
    -- model = 'gpt-4o-mini',
    model = 'gemini-2.5-pro',
  })
end

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

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    keys = {
      { '<leader>cc', mode = { 'v', 'n' }, '<CMD>CopilotChatToggle<CR>', desc = 'CopilotChat - Open' },
      { '<leader>ce', mode = { 'v', 'n' }, '<CMD>CopilotChatExplain<CR>', desc = 'CopilotChat - Explain' },
      { '<leader>cf', mode = { 'v', 'n' }, '<CMD>CopilotChatFix<CR>', desc = 'CopilotChat - Fix' },
      { '<leader>ch', mode = { 'v', 'n' }, list_chat_history, desc = 'CopilotChat - History' },
      { '<leader>cm', mode = { 'v', 'n' }, '<CMD>CopilotChatModels<CR>', desc = 'CopilotChat - Models' },
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
          -- require('CopilotChat.integrations.snacks').pick(actions.prompt_actions())
          require('CopilotChat.integrations.snacks').pick(actions.prompt_actions())
          -- require('CopilotChat').select_prompt(actions.prompt_actions())
          -- require('CopilotChat').select_prompt(actions.prompt_actions())
        end,
        desc = 'CopilotChat - Prompt actions',
      },
      {
        '<leader>cg',
        function()
          local input = vim.fn.input 'Eggbert Chat:'
          if input ~= '' then
            require('CopilotChat').ask(input, {
              system_prompt = 'You are a helpful assistant for a programmer at the level of someone with a B.S. in CS. The Programmer is familar with C# but not with the Godot Game Engine. This is their first game',
              selection = require('CopilotChat.select').buffer,
              context = 'This is involving a Game made in Godot 4.3 with C# . The game in question is like Undertale. It has an overworld style and aesthetic to that of Undertale, but the combat loop is that of like a bullet-hell game.',
              sticky = {
                '#files',
              },
            })
          end
        end,
        desc = 'CopilotChat - Eggbert',
      },
    },
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    -- build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      -- model = 'claude-3.7-sonnet', -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
      model = 'gpt-4.1',
      window = {
        layout = 'vertical',
        -- height = 0.5,
      },
      -- sticky = {
      --   '#files',
      -- },
      callback = function(response)
        save_chat(response)
      end,
      history_path = CHAT_HISTORY_DIR,
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
