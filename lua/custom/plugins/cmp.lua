return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      cmp.setup {
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
          { name = 'path' },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<C-p>'] = cmp.mapping.select_prev_item(), -- previous suggestion
          ['<C-n>'] = cmp.mapping.select_next_item(), -- next suggestion
          ['<C-e>'] = cmp.mapping.confirm { select = true }, -- select suggestion
          ['<C-u>'] = cmp.mapping.scroll_docs(4), -- scroll up preview
          ['<C-d>'] = cmp.mapping.scroll_docs(-4), -- scroll down preview
          ['<C-Space>'] = cmp.mapping.complete {}, -- show completion suggestions
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          -- ["<C-c>"] = cmp.mapping.abort(), -- close completion window
        },
        formatting = {
          format = function(_, item)
            local icons = require('lazyvim.config').icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = {
            hl_group = 'CmpGhostText',
          },
        },
      }
    end,
  },
}

-- return {
--   'hrsh7th/nvim-cmp',
--   version = false, -- last release is way too old
--   -- event = "InsertEnter",
--   event = { 'BufReadPost', 'BufNewFile' },
--   dependencies = {
--     'hrsh7th/cmp-nvim-lsp',
--     'hrsh7th/cmp-buffer',
--     'hrsh7th/cmp-path',
--     'saadparwaiz1/cmp_luasnip',
--   },
--   -- Not all LSP servers add brackets when completing a function.
--   -- To better deal with this, LazyVim adds a custom option to cmp,
--   -- that you can configure. For example:
--   --
--   -- ```lua
--   -- opts = {
--   --   auto_brackets = { "python" }
--   -- }
--   -- ```
--
--   opts = function()
--     vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
--     local cmp = require 'cmp'
--     local defaults = require 'cmp.config.default'()
--     return {
--       auto_brackets = {}, -- configure any filetype to auto add brackets
--       completion = {
--         completeopt = 'menu,menuone,noinsert',
--       },
--       window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--       },
--       mapping = cmp.mapping.preset.insert {
--         ['<C-p>'] = cmp.mapping.select_prev_item(), -- previous suggestion
--         ['<C-n>'] = cmp.mapping.select_next_item(), -- next suggestion
--         ['<C-e>'] = cmp.mapping.confirm { select = true }, -- select suggestion
--         ['<C-u>'] = cmp.mapping.scroll_docs(4), -- scroll up preview
--         ['<C-d>'] = cmp.mapping.scroll_docs(-4), -- scroll down preview
--         ['<C-Space>'] = cmp.mapping.complete {}, -- show completion suggestions
--         ['<Tab>'] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_next_item()
--           elseif luasnip.expand_or_jumpable() then
--             luasnip.expand_or_jump()
--           else
--             fallback()
--           end
--         end, { 'i', 's' }),
--         ['<S-Tab>'] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_prev_item()
--           elseif luasnip.jumpable(-1) then
--             luasnip.jump(-1)
--           else
--             fallback()
--           end
--         end, { 'i', 's' }),
--         -- ["<C-c>"] = cmp.mapping.abort(), -- close completion window
--       },
--       sources = cmp.config.sources({
--         { name = 'nvim_lsp' },
--         { name = 'path' },
--       }, {
--         { name = 'buffer' },
--       }),
--       formatting = {
--         format = function(_, item)
--           local icons = require('lazyvim.config').icons.kinds
--           if icons[item.kind] then
--             item.kind = icons[item.kind] .. item.kind
--           end
--           return item
--         end,
--       },
--       experimental = {
--         ghost_text = {
--           hl_group = 'CmpGhostText',
--         },
--       },
--       sorting = defaults.sorting,
--     }
--   end,
--
--   ---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
--   config = function(_, opts)
--     for _, source in ipairs(opts.sources) do
--       source.group_index = source.group_index or 1
--     end
--     local cmp = require 'cmp'
--     local Kind = cmp.lsp.CompletionItemKind
--     cmp.setup(opts)
--     cmp.event:on('confirm_done', function(event)
--       if not vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
--         return
--       end
--       local entry = event.entry
--       local item = entry:get_completion_item()
--       if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) and item.insertTextFormat ~= 2 then
--         local cursor = vim.api.nvim_win_get_cursor(0)
--         local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
--         if prev_char ~= '(' and prev_char ~= ')' then
--           local keys = vim.api.nvim_replace_termcodes('()<left>', false, false, true)
--           vim.api.nvim_feedkeys(keys, 'i', true)
--         end
--       end
--     end)
--   end,
-- }
--
-- vim: ts=2 sts=2 sw=2 et
