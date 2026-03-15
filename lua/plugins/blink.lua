return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = { auto_show = true },
      },
    },

    keymap = {
      preset = 'default',
      ['<C-space>'] = { 'show' },
      ['<C-s>'] = {
        function(cmp)
          cmp.show { providers = { 'snippets' } }
        end,
      },
      ['<C-l>'] = {
        function(cmp)
          cmp.show { providers = { 'lsp' } }
        end,
      },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-c>'] = { 'cancel', 'hide' },
      ['<C-e>'] = { 'select_and_accept' },
    },

    signature = {
      enabled = true,
      window = {
        border = 'padded',
        winblend = 0,
      },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
      kind_icons = {
        Text = '󰉿',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '󰒓',
        Field = '󰜢',
        Variable = '󰀫',
        Property = '󰖷',
        Class = '󰠱',
        Interface = '󰕘',
        Struct = '󰙅',
        Module = '󰏗',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '󰕘',
        EnumMember = '󰕘',
        Keyword = '󰌋',
        Constant = '󰏿',
        Snippet = '󰩫',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        Event = '󰉒',
        Operator = '󰆕',
        TypeParameter = '󰬛',
      },
    },

    completion = {
      ghost_text = { enabled = false },

      menu = {
        scrollbar = false,
        border = 'padded',
        winblend = 0,
        direction_priority = { 'n', 's' },

        draw = {
          padding = 1,
          gap = 1,

          columns = {
            { 'kind_icon', gap = 1 },
            { 'label', 'label_description', gap = 1 },
            { 'kind' },
          },

          components = {
            kind_icon = {
              text = function(ctx)
                return ctx.kind_icon
              end,
              highlight = function(ctx)
                return 'BlinkCmpKind' .. ctx.kind
              end,
            },

            label = {
              text = function(ctx)
                return ctx.label
              end,
              highlight = function(ctx)
                return ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel'
              end,
            },

            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_detail
              end,
              highlight = 'Comment',
            },

            kind = {
              width = { fill = true },
              text = function(ctx)
                return ctx.kind
              end,
              highlight = function(ctx)
                return 'BlinkCmpKind' .. ctx.kind
              end,
            },
          },

          treesitter = { 'lsp' },
        },
      },

      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
        window = {
          border = 'padded',
          winblend = 0,
          max_height = 80,
          max_width = 85,
          direction_priority = {
            menu_north = { 'e', 'w', 'n', 's' },
            menu_south = { 'e', 'w', 's', 'n' },
          },
        },
      },

      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod', 'lazydev' },
      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      },
    },
  },

  config = function(_, opts)
    require('blink.cmp').setup(opts)

    -- High contrast highlights
    local function set_high_contrast_highlights()
      -- Bold selection with strong contrast
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', {
        bg = vim.api.nvim_get_hl(0, { name = 'PmenuSel' }).bg,
        bold = true,
      })

      -- Make label match stand out
      vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', {
        bold = true,
        fg = vim.api.nvim_get_hl(0, { name = 'Special' }).fg,
      })

      -- Clear background for crisp look
      vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { link = 'Pmenu' })
      vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { link = 'NormalFloat' })
      vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { link = 'NormalFloat' })
    end

    set_high_contrast_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('BlinkCmpHighContrast', { clear = true }),
      callback = set_high_contrast_highlights,
    })
  end,

  opts_extend = { 'sources.default' },
}

-- vim: ts=2 sts=2 sw=2 et
