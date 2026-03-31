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
    -- Use Rust implementation for better performance
    -- Requires building from source: cd ~/.local/share/nvim/site/pack/_/opt/blink.cmp && cargo build --release
    implementation = 'prefer_rust',
    prebuilt_binaries = {
      -- Ignore version mismatch for locally built binary
      ignore_version_mismatch = true,
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

-- Strip markdown from documentation windows
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    -- Only process floating windows (documentation popups)
    local winid = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(winid)
    if config.relative and config.relative ~= '' then
      -- It's a floating window
      vim.schedule(function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local stripped = {}
        for _, line in ipairs(lines) do
          -- Remove code block delimiters
          line = line:gsub('^%s*```[%w]*%s*$', '')
          -- Remove headers
          line = line:gsub('^%s*#+%s*', '')
          -- Remove inline code backticks
          line = line:gsub('`([^`]+)`', '%1')
          -- Remove bold/italic
          line = line:gsub('%*%*([^*]+)%*%*', '%1')
          line = line:gsub('%*([^*]+)%*', '%1')
          line = line:gsub('_([^_]+)_', '%1')
          if line ~= '' then
            table.insert(stripped, line)
          end
        end
        vim.api.nvim_buf_set_lines(0, 0, -1, false, stripped)
      end)
    end
  end,
  group = vim.api.nvim_create_augroup('BlinkCmpStripMarkdown', { clear = true }),
})
