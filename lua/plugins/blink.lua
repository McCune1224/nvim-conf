-- ============================================================================
-- Blink.cmp Configuration
-- Modern completion engine
-- ============================================================================

-- Install plugins
vim.pack.add {
  'https://github.com/saghen/blink.cmp',
  'https://github.com/saghen/blink.lib',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
}

-- Load the plugin (vim.pack puts plugins in opt/, need packadd to load)
vim.cmd 'packadd blink.cmp'

local ok_blink, blink = pcall(require, 'blink.cmp')
if not ok_blink then
  vim.notify('blink.cmp not loaded yet - will be available after restart', vim.log.levels.WARN)
  return
end

-- Check if Rust fuzzy matcher is available
local has_rust_lib = blink.library_available()

-- Build if needed (run this once, then restart Neovim)
-- To rebuild manually: :lua require('blink.cmp').build():wait(60000)
if not has_rust_lib then
  vim.notify('blink.cmp: Building Rust fuzzy matcher... (please wait)', vim.log.levels.INFO)
  vim.notify('Run :lua require("blink.cmp").build():wait(60000) and then restart Neovim', vim.log.levels.WARN)
end

-- require('blink.cmp').download({ force = true, tags = '*' }):wait(60000)

blink.build():wait(60000)
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
      direction_priority = { 's', 'n' },
    },
  },

  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = 'mono',
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
        score_offset = 100,
      },
    },
  },

  fuzzy = {
    -- Use 'prefer_rust_with_warning' to fallback to Lua if Rust lib not available
    -- Change to 'rust' after building for better performance
    implementation = has_rust_lib and 'rust' or 'prefer_rust_with_warning',
  },
}

-- if has_rust_lib then
--   vim.notify('blink.cmp: Using Rust fuzzy matcher', vim.log.levels.INFO)
-- else
--   vim.notify('blink.cmp: Using Lua fallback (run build for Rust performance)', vim.log.levels.WARN)
-- end
