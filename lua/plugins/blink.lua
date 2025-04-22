return {

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
    cmdline = {
      keymap = {
        preset = 'inherit',
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
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
      ['[s'] = { 'snippet_backward' }, -- move to previous snippet position
      [']s'] = { 'snippet_backward' }, -- move to next snippet position
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
      -- kind_icons = {
      --   Copilot = '',
      -- },
    },

    completion = {
      ghost_text = { enabled = false },
      menu = {
        scrollbar = false,
        border = 'none',
        direction_priority = {
          'n',
          's',
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
          border = 'padded',
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
      -- default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'dadbod' },
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
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
            kind_name = 'Copilot', ---@type string | false
            kind_icon = ' ', ---@type string | false
            kind_hl = false, ---@type string | false
            debounce = 200, ---@type integer | false
            auto_refresh = {
              backward = true,
              forward = true,
            },
          },
        },
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      },
    },
  },
  opts_extend = { 'sources.default' },
}
