-- ============================================================================
-- Blink.cmp Configuration
-- Modern completion engine
-- ============================================================================

-- Install plugin
vim.pack.add {
  'https://github.com/saghen/blink.cmp',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
}

local blink = require 'blink.cmp'

blink.setup {
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
      border = 'single',
      winblend = 0,
      max_height = 10,
      max_width = 80,
      direction_priority = { 's', 'n' }, -- Prefer showing below cursor, fallback to above
    },
  },

  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
    -- kind_icons = {
    --   Text = '󰉿',
    --   Method = '󰊕',
    --   Function = '󰊕',
    --   Constructor = '󰒓',
    --   Field = '󰜢',
    --   Variable = '󰀫',
    --   Property = '󰖷',
    --   Class = '󰠱',
    --   Interface = '󰕘',
    --   Struct = '󰙅',
    --   Module = '󰏗',
    --   Unit = '󰑭',
    --   Value = '󰎠',
    --   Enum = '󰕘',
    --   EnumMember = '󰕘',
    --   Keyword = '󰌋',
    --   Constant = '󰏿',
    --   Snippet = '󰩫',
    --   Color = '󰏘',
    --   File = '󰈙',
    --   Reference = '󰈇',
    --   Folder = '󰉋',
    --   Event = '󰉒',
    --   Operator = '󰆕',
    --   TypeParameter = '󰬛',
    -- },
  },

  completion = {
    ghost_text = { enabled = false },

    menu = {
      scrollbar = false,
      border = 'single',
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
      treesitter_highlighting = false,
      window = {
        border = 'single',
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
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      sql = { 'snippets', 'dadbod', 'buffer' },
    },
    providers = {
      dadbod = {
        name = 'Dadbod',
        module = 'vim_dadbod_completion.blink',
        score_offset = 100, -- Prioritize dadbod suggestions in SQL
      },
    },
  },

  fuzzy = {
    -- 'prefer_rust_with_warning' (Recommended) - Auto-download prebuilt binaries, fallback to Lua with warning
    -- 'prefer_rust' - Use Rust if available, fallback to Lua silently
    -- 'rust' - Always use Rust, error if not available
    -- 'lua' - Always use Lua implementation
    implementation = 'lua',
    prebuilt_binaries = {
      -- download = true, -- Auto-download prebuilt binaries from GitHub
      ignore_version_mismatch = false, -- Set true if building from source manually
    },
  },
}

-- High contrast highlights
local function set_high_contrast_highlights()
  -- Bold selection with strong contrast
  local pmenu_sel = vim.api.nvim_get_hl(0, { name = 'PmenuSel' })
  vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', {
    bg = pmenu_sel.bg,
    bold = true,
  })

  -- Make label match stand out
  local special = vim.api.nvim_get_hl(0, { name = 'Special' })
  vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', {
    bold = true,
    fg = special.fg,
  })

  -- Clear background for crisp look
  vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { link = 'Pmenu' })
  vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { link = 'NormalFloat' })
  vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { link = 'NormalFloat' })
end

-- set_high_contrast_highlights()
--
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   group = vim.api.nvim_create_augroup('BlinkCmpHighContrast', { clear = true }),
--   callback = set_high_contrast_highlights,
-- })


