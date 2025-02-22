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

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
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
          local builtin = require 'telescope.builtin'
          local themes = require 'telescope.themes'
          local opts = {}
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-t>.
          -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gd', function()
            builtin.lsp_definitions(themes.get_ivy(opts))
          end, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gr', function()
            builtin.lsp_references(themes.get_ivy(opts))
          end, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          -- map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gI', function()
            builtin.lsp_implementations(themes.get_ivy(opts))
          end, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>D', function()
            builtin.lsp_type_definitions(themes.get_ivy(opts))
          end, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ds', function()
            builtin.lsp_document_symbols(themes.get_ivy(opts))
          end, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>ws', function()
            builtin.lsp_dynamic_workspace_symbols(themes.get_ivy(opts))
          end, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

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

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>df',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[D]ocument [F]ormat ',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {

        -- {lsp_format}
        --     `"never"`    never use the LSP for formatting (default)
        --     `"fallback"` LSP formatting is used when no other formatters are available
        --     `"prefer"`   use only LSP formatting when available
        --     `"first"`    LSP formatting is used when available and then other formatters
        --     `"last"`     other formatters are used then LSP formatting when
        lua = { 'stylua', lsp_format = 'fallback' },
        -- python = { 'isort', 'black', lsp_format = 'fallback' },
        go = { 'goimports', lsp_format = 'last' },
        sql = { 'sql-formatter', 'sqlfmt', stop_after_first = true, lsp_format = 'fallback' },
        --
        javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      },
    },
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

  {

    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    -- dependencies = { 'rafamadriz/friendly-snippets', 'giuxtaposition/blink-cmp-copilot' },
    dependencies = { 'rafamadriz/friendly-snippets', 'fang2hou/blink-copilot' },

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      --
      keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show' },
        ['<C-s>'] = {
          function(cmp)
            cmp.show { providers = { 'snippets' } }
          end,
        }, -- show only snippets options
        ['<C-l>'] = {
          function(cmp)
            cmp.show { providers = { 'lsp' } }
          end,
        }, -- show only lsp options
        ['<C-a>'] = {
          function(cmp)
            cmp.show { providers = { 'copilot' } }
          end,
        }, -- show only copilot option

        ['<C-k>'] = { 'select_prev', 'fallback' }, -- previous suggestion
        ['<C-j>'] = { 'select_next', 'fallback' }, -- next suggestion
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-c>'] = { 'cancel', 'hide' }, -- close completion window
        ['<C-e>'] = { 'select_and_accept' }, -- select suggestion
      },
      signature = { enabled = true },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
        kind_icons = {
          Copilot = '',
        },
      },

      completion = {
        ghost_text = { enabled = false },
        menu = {
          scrollbar = false,
          border = 'rounded',
          direction_priority = {
            's',
            'n',
          },
          draw = {
            columns = {
              { 'kind_icon', 'label_description', gap = 1 },
              { 'label', 'kind', gap = 1 },
            },
            treesitter = { 'true' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          treesitter_highlighting = true,
          window = {
            border = 'rounded',
            max_height = 80,
            max_width = 80,
            direction_priority = {
              menu_north = { 'w', 'e', 'n', 's' },
              menu_south = { 'w', 'e', 's', 'n' },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'dadbod' },
        providers = {
          -- copilot = {
          --   name = 'copilot',
          --   module = 'blink-cmp-copilot',
          --   score_offset = -1, -- Never have this be in position 1. 9/10 times this hijacks the first item (i.e lsp option) and is annoying
          --   async = true,
          --   transform_items = function(_, items)
          --     local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
          --     local kind_idx = #CompletionItemKind + 1
          --     CompletionItemKind[kind_idx] = 'Copilot'
          --     for _, item in ipairs(items) do
          --       item.kind = kind_idx
          --     end
          --     return items
          --   end,
          -- },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            -- score_offset = -3,
            score_offset = -100,
            async = true,
            opts = {
              max_completions = 3,
              max_attempts = 4,
            },
          },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
