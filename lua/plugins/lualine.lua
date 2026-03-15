return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    opts = {
      override = {
        go = { icon = '', color = '#73cadb', name = 'go' },
      },
      override_by_filename = {
        ['go.mod'] = { icon = '', color = '#73cadb', name = 'go' },
        ['go.sum'] = { icon = '', color = '#73cadb', name = 'go' },
      },
    },
  },
  opts = {
    options = {
      globalstatus = true,
      always_divide_middle = false,
      component_separators = { left = '│', right = '│' },
      section_separators = { left = '', right = '' },
      theme = 'auto',
      disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
    },
    sections = {
      lualine_a = {},
      lualine_b = {
        'branch',
        {
          'diff',
          symbols = { added = '+', modified = '~', removed = '-' },
        },
      },
      lualine_c = {
        { 'filename', path = 1 },
      },
      lualine_x = {
        {
          'diagnostics',
          symbols = { error = '', warn = '', info = '', hint = '' },
        },
        'searchcount',
      },
      lualine_y = {},
      lualine_z = {
        {
          'location',
          fmt = function(str)
            return str:gsub(' ', '')
          end,
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'aerial' },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          'tabs',
          mode = 1,
          max_length = vim.o.columns,
        },
      },
    },
    extensions = { 'lazy', 'mason', 'quickfix', 'trouble', 'neo-tree', 'symbols-outline', 'oil' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
