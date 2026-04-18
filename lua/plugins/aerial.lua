-- ============================================================================
-- Aerial.nvim - Code Outline/Navigation Plugin
-- Provides breadcrumbs and symbol navigation
-- Integrated with Lualine for breadcrumb display
-- ============================================================================

vim.pack.add({
  'https://github.com/stevearc/aerial.nvim',
})

local ok, aerial = pcall(require, 'aerial')
if not ok then
  return
end

aerial.setup({
  -- Priority list of backends to use for fetching symbols
  -- 'lsp' uses LSP document symbols
  -- 'treesitter' uses Treesitter queries
  -- 'markdown' uses markdown parser
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },

  -- How the aerial window will be displayed
  layout = {
    -- Resize the window to fit the longest symbol
    resize_to_content = true,
    -- The minimum width of the aerial window
    min_width = 20,
    -- The maximum width of the aerial window
    max_width = { 40, 0.2 },
    -- How the aerial window will be placed
    -- 'window' - floating window
    -- 'split' - horizontal split
    -- 'vsplit' - vertical split
    default_direction = 'right',
    -- Determines where the aerial window will be opened
    -- relative to the current window
    placement = 'window',
    -- When true, don't aerial to take up more than 50% of the window
    preserve_equality = false,
  },

  -- Determines how the aerial window is rendered
  -- 'classic' - The classic tree view with collapsable nodes
  -- 'compact' - Compact view with symbols inline
  -- 'tree' - Tree view with indent guides
  render_mode = 'classic',

  -- Determines the default symbols to show
  filter_kind = {
    'Class',
    'Constructor',
    'Enum',
    'Function',
    'Interface',
    'Module',
    'Method',
    'Struct',
    'Trait',
    'Field',
    'Property',
    'Variable',
    'Constant',
    'EnumMember',
  },

  -- When true, open aerial automatically when entering a supported buffer
  open_automatic = false,

  -- Keymaps for aerial window
  keymaps = {
    ['?'] = 'actions.show_help',
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.jump',
    ['<2-LeftMouse>'] = 'actions.jump',
    ['<C-v>'] = 'actions.jump_vsplit',
    ['<C-s>'] = 'actions.jump_split',
    ['p'] = 'actions.scroll',
    ['<C-j>'] = 'actions.down_and_scroll',
    ['<C-k>'] = 'actions.up_and_scroll',
    ['{'] = 'actions.prev',
    ['}'] = 'actions.next',
    ['[['] = 'actions.prev_up',
    [']]'] = 'actions.next_up',
    ['q'] = 'actions.close',
    ['o'] = 'actions.tree_toggle',
    ['O'] = 'actions.tree_toggle_recursive',
    ['za'] = 'actions.tree_toggle',
    ['zA'] = 'actions.tree_toggle_recursive',
    ['l'] = 'actions.tree_open',
    ['L'] = 'actions.tree_open_recursive',
    ['zo'] = 'actions.tree_open',
    ['zO'] = 'actions.tree_open_recursive',
    ['h'] = 'actions.tree_close',
    ['H'] = 'actions.tree_close_recursive',
    ['zc'] = 'actions.tree_close',
    ['zC'] = 'actions.tree_close_recursive',
    ['zr'] = 'actions.tree_increase_fold_level',
    ['zR'] = 'actions.tree_open_recursive',
    ['zm'] = 'actions.tree_decrease_fold_level',
    ['zM'] = 'actions.tree_close_recursive',
    ['zx'] = 'actions.tree_sync_folds',
    ['zX'] = 'actions.tree_sync_folds',
  },

  -- When true, aerial will highlight the symbol under the cursor
  highlight_on_hover = true,

  -- Automatically close aerial when jumping to a symbol
  close_on_select = false,

  -- Automatically jump to symbol when cursor is on a line with a symbol
  autojump = false,

  -- Options for the floating nav window
  nav = {
    border = 'single',
    max_height = 0.9,
    min_height = { 10, 0.1 },
    max_width = 0.5,
    min_width = { 0.2, 20 },
    win_opts = {
      cursorline = true,
      winblend = 10,
    },
    -- Jump to symbol in source window when navigating in aerial nav
    autojump = false,
    -- Keymaps for nav window
    keymaps = {
      ['<CR>'] = 'actions.jump',
      ['<2-LeftMouse>'] = 'actions.jump',
      ['<C-v>'] = 'actions.jump_vsplit',
      ['<C-s>'] = 'actions.jump_split',
      ['h'] = 'actions.left',
      ['l'] = 'actions.right',
      ['<C-c>'] = 'actions.close',
      ['q'] = 'actions.close',
      ['<Esc>'] = 'actions.close',
    },
  },

  -- LSP options
  lsp = {
    -- Fetch document symbols when LSP diagnostics update
    diagnostics_trigger_update = true,
    -- Set to false to not update the symbols when there are LSP errors
    update_when_errors = true,
    -- How long to wait (in ms) after a buffer change before updating
    -- Only used when diagnostics_trigger_update = false
    update_delay = 300,
  },

  -- Treesitter options
  treesitter = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },

  -- Markdown options
  markdown = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },

  -- Man options
  man = {
    -- How long to wait (in ms) after a buffer change before updating
    update_delay = 300,
  },

  -- Icons for different symbol kinds
  icons = {
    Collapsed = '▸',
    Expanded = '▾',
    Class = '󰠱',
    Constructor = '󰆧',
    Enum = '󰕘',
    EnumMember = '󰕘',
    Event = '󱐋',
    Field = '󰜢',
    File = '󰈙',
    Function = '󰊕',
    Interface = '󰕘',
    Key = '󰌋',
    Method = '󰆧',
    Module = '󰏗',
    Namespace = '󰌗',
    Null = '󰟢',
    Number = '󰎠',
    Object = '󰅩',
    Operator = '󰆕',
    Package = '󰏗',
    Property = '󰜢',
    String = '󰀬',
    Struct = '󰙅',
    TypeParameter = '󰗴',
    Variable = '󰀫',
    Constant = '󰏿',
    Array = '󰅪',
    Boolean = '󰨙',
    Component = '󰅴',
    Fragment = '󰅴',
    TypeAlias = '󰜁',
    Parameter = '󰏗',
    StaticMethod = '󰆧',
    Macro = '󰉨',
  },

  -- Highlight groups to link to
  highlight_mode = 'split_width',
  highlight_closest = true,
  highlight_on_jump = 300,

  -- Post-processing function to modify symbols before display
  post_parse_symbol = function(bufnr, item, ctx)
    return true
  end,

  -- Post-processing function to filter symbols
  post_add_symbol = function(bufnr, item, ctx)
    return true
  end,
})

-- Keymaps for aerial
vim.keymap.set('n', '<leader>ao', '<cmd>AerialOpen<cr>', { desc = 'Aerial: Open outline' })
vim.keymap.set('n', '<leader>ac', '<cmd>AerialClose<cr>', { desc = 'Aerial: Close outline' })
vim.keymap.set('n', '<leader>at', '<cmd>AerialToggle<cr>', { desc = 'Aerial: Toggle outline' })
vim.keymap.set('n', '<leader>an', '<cmd>AerialNext<cr>', { desc = 'Aerial: Next symbol' })
vim.keymap.set('n', '<leader>ap', '<cmd>AerialPrev<cr>', { desc = 'Aerial: Previous symbol' })
vim.keymap.set('n', '<leader>ag', '<cmd>AerialNavOpen<cr>', { desc = 'Aerial: Open nav window' })

-- Optional: Open aerial on specific filetypes automatically
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('AerialAutoOpen', { clear = true }),
  pattern = { 'go', 'lua', 'python', 'javascript', 'typescript', 'rust' },
  callback = function(args)
    -- Uncomment below to auto-open aerial for these filetypes
    -- aerial.open()
  end,
})
