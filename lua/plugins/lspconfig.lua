return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
      'folke/snacks.nvim',
      -- Useful status updates for LSP.
      -- -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- Custom Diagnostic Symbols
          local x = vim.diagnostic.severity
          vim.diagnostic.config {
            virtual_text = { prefix = '' },
            signs = { text = { [x.ERROR] = '', [x.WARN] = '', [x.INFO] = '󰋽', [x.HINT] = '' } },
            underline = true,
            float = { border = 'single' },
          }
          -- function that lets us more easily define mappings specific for LSP related items. It sets the mode, buffer and description for us each time.
          -- local builtin = require 'telescope.builtin'
          -- local themes = require 'telescope.themes'
          local snacks = require 'snacks'

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-t>.
          -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- map('gd', function()
          --   builtin.lsp_definitions(themes.get_ivy(opts))
          -- end, '[G]oto [D]efinition')
          map('gd', function()
            snacks.picker.lsp_definitions()
          end, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          -- map('gr', function()
          --   builtin.lsp_references(themes.get_ivy(opts))
          -- end, '[G]oto [R]eferences')
          map('gr', function()
            snacks.picker.lsp_references()
          end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          -- map('gI', function()
          --   builtin.lsp_implementations(themes.get_ivy(opts))
          -- end, '[G]oto [I]mplementation')
          map('gI', function()
            snacks.picker.lsp_implementations()
          end, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          -- map('<leader>D', function()
          --   builtin.lsp_type_definitions(themes.get_ivy(opts))
          -- end, 'Type [D]efinition')
          map('<leader>D', function()
            snacks.picker.lsp_type_definitions()
          end, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          -- map('<leader>ds', function()
          --   builtin.lsp_document_symbols(themes.get_ivy(opts))
          -- end, '[D]ocument [S]ymbols')
          map('<leader>ds', function()
            snacks.picker.lsp_symbols()
          end, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          -- map('<leader>ws', function()
          --   builtin.lsp_dynamic_workspace_symbols(themes.get_ivy(opts))
          -- end, '[W]orkspace [S]ymbols')
          map('<leader>dS', function()
            snacks.picker.lsp_workspace_symbols()
          end, '[D]ocument [S]ymbols (Global)')

          -- Rename the variable under your cursor.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
          ---@diagnostic disable-next-line: duplicate-set-field
          function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = 'single' -- Or any other border
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
          end
          -- Opens a popup that displays documentation about the word under your cursor
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- Goto Declaration, (in langs like C this would take you to the header)
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Restart LSP Server
          map('<leader>cr', '<cmd>LspRestart<cr>', '[C]ode [R]estart')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      local blink_capabilities = require('blink.cmp').get_lsp_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities(config.capabilities))
      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local nvim_lsp_util = require 'lspconfig.util'
      local servers = {
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        -- elixirls = {},
        -- lexical = {},
        gopls = {},
        omnisharp = {},
        rust_analyzer = {},
        svelte = {},
        tailwindcss = {},
        clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        --
        html = {
          filetypes = { 'html', 'templ', 'svelte' },
        },

        denols = {
          root_dir = nvim_lsp_util.root_pattern('deno.json', 'deno.jsonc'),
        },
        ts_ls = {
          root_dir = nvim_lsp_util.root_pattern 'package.json',
          single_file_support = false,
        },
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()
      require('mason-nvim-dap').setup {
        ensure_installed = { 'python', 'delve', 'elixir', 'coreclr' },
        handlers = {}, -- sets up dap in the predefined manner
      }
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        -- 'goimports',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            -- server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            server.capabilities = vim.tbl_deep_extend('force', {}, blink_capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      -- No currently official gleam lsp for Mason, so manuall adding via lspconfig
      -- require('lspconfig').gleam.setup {
      --   cmd = { 'gleam', 'lsp' },
      --   filetypes = { 'gleam' },
      --   capabilities = capabilities,
      -- }
      local lspconfig = require 'lspconfig'
      lspconfig.gleam.setup {}
      lspconfig.gdscript.setup = {
        name = 'godot',
        cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
        capabilities = blink_capabilities,
      }
      -- local gd_port = os.getenv 'GDScript_Port' or '6005'
      -- local gd_cmd = { 'ncat', '127.0.0.1', gd_port }
      -- local gd_pipe = [[\\.\pipe\godot.pipe]]
      -- lspconfig.gdscript.setup {
      --   capabilities = vim.tbl_deep_extend('force', {}, capabilities, lspconfig.gdscript.capabilities or {}), -- cmd = gd_cmd,
      -- }
    end,
  },

  -- {
  --   'hrsh7th/nvim-cmp',
  --   lazy = false,
  --   priority = 100,
  --   dependencies = {
  --     'onsails/lspkind.nvim',
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --     'hrsh7th/cmp-buffer',
  --     'nvim-tree/nvim-web-devicons',
  --     {
  --       'L3MON4D3/LuaSnip',
  --       dependencies = { 'rafamadriz/friendly-snippets' },
  --       build = 'make install_jsregexp',
  --     },
  --     'saadparwaiz1/cmp_luasnip',
  --   },
  --
  --   config = function()
  --     vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
  --     vim.opt.shortmess:append 'c'
  --
  --     local cmp = require 'cmp'
  --
  --     require('luasnip.loaders.from_vscode').lazy_load()
  --     cmp.setup {
  --       snippet = {
  --         expand = function(args)
  --           require('luasnip').lsp_expand(args.body)
  --         end,
  --       },
  --       sources = {
  --         { name = 'nvim_lsp', priority = 750, group_index = 1 },
  --         { name = 'luasnip', priority = 1000, group_index = 1 },
  --         { name = 'buffer', priority = 500, group_index = 2 },
  --         -- { name = 'copilot', priority = 650, group_index = 2 },
  --         { name = 'path', priority = 100, group_index = 3 },
  --       },
  --       mapping = cmp.mapping.preset.insert {
  --         ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
  --         ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
  --         -- ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- scroll up preview
  --         -- ['<C-d>'] = cmp.mapping.scroll_docs(4), -- scroll down preview
  --         ['<C-Space>'] = cmp.mapping.complete {}, -- show completion suggestions
  --         ['<C-c>'] = cmp.mapping.abort(), -- close completion window
  --         ['<C-e>'] = cmp.mapping.confirm { select = true }, -- select suggestion
  --       },
  --
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       formatting = {
  --         fields = { 'kind', 'abbr', 'menu' },
  --         format = function(entry, vim_item)
  --           local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, vim_item)
  --           local strings = vim.split(kind.kind, '%s', { trimempty = true })
  --           kind.kind = ' ' .. (strings[1] or '') .. ' '
  --           kind.menu = '    (' .. (strings[2] or '') .. ')'
  --
  --           return kind
  --         end,
  --       },
  --       --
  --       -- formatting = {
  --       --   format = lspkind.cmp_format {
  --       --     mode = 'text_symbol',
  --       --     -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
  --       --     -- can also be a function to dynamically calculate max width such as
  --       --     maxwidth = function()
  --       --       return math.floor(0.45 * vim.o.columns)
  --       --     end,
  --       --     ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
  --       --     show_labelDetails = true, -- show labelDetails in menu. Disabled by default
  --       --
  --       --     -- The function below will be called before any actual modifications from lspkind
  --       --     -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
  --       --     -- before = function (entry, vim_item)
  --       --     --   ...
  --       --     --   return vim_item
  --       --     -- end
  --       --   },
  --       -- },
  --       sorting = {
  --         priority_weight = 2,
  --         comparators = {
  --           cmp.config.compare.offset,
  --           cmp.config.compare.exact,
  --           cmp.config.compare.score,
  --           cmp.config.compare.recently_used,
  --           cmp.config.compare.kind,
  --           cmp.config.compare.sort_text,
  --           cmp.config.compare.length,
  --           cmp.config.compare.order,
  --         },
  --       },
  --
  --       experimental = {
  --         ghost_text = true,
  --       },
  --     }
  --
  --     cmp.setup.filetype({ 'sql' }, {
  --       sources = {
  --         { name = 'vim-dadbod-completion' },
  --         { name = 'buffer' },
  --         { name = 'supermaven' },
  --       },
  --     })
  --
  --     local ls = require 'luasnip'
  --     ls.config.set_config {
  --       history = false,
  --       updateevents = 'TextChanged,TextChangedI',
  --     }
  --
  --     vim.keymap.set({ 'i', 's' }, '<c-d>', function()
  --       if ls.expand_or_jumpable() then
  --         ls.expand_or_jump()
  --       end
  --     end, { silent = true })
  --
  --     vim.keymap.set({ 'i', 's' }, '<c-u>', function()
  --       if ls.jumpable(-1) then
  --         ls.jump(-1)
  --       end
  --     end, { silent = true })
  --   end,
  -- },
}
