return {
  { 'AndreM222/copilot-lualine' },
  {

    opts = {

      -- '█' '█'  -- solid blocks
      -- '▊' '▊'  -- partial blocks
      -- '▌' '▐'  -- half blocks
      -- '█' '█'  -- solid blocks
      options = {
        -- theme = bubbles_theme,
        -- component_separators = { left = '', right = '' },
        -- component_separators = { left = '|', right = '|' },
        -- component_separators = { left = '', right = '' },
        -- component_separators = { left = '|', right = '|' },
        component_separators = { '' },

        section_separators = { left = '', right = '' },
        -- section_separators = { left = '█', right = '█' },
        -- section_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
      },
      sections = {
        -- lualine_a = { 'mode', { 'filename', separator = { left = '' }, right_padding = 2, path = 1 } },
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { 'tabs', show_modified_status = false, use_mode_colors = true },
          { 'filename', path = 1 },
          'diagnostics',
        },
        -- lualine_c = {
        --   -- { 'diagnostics' },
        --   '%=',
        --   -- { 'aerial' },
        --   -- { 'filename', path = 1 },
        --   -- { 'aerial' },
        -- },
        -- lualine_c = { "os.date('%a')", 'data', "require'lsp-status'.status()" }
        -- lualine_x = { 'copilot' },
        lualine_x = { 'branch', 'diff' },
        lualine_y = {},
        lualine_z = {
          -- 'diff',
          -- 'branch',
        },
      },

      tabline = {
        lualine_c = { 'aerial' },
        --
        lualine_x = { 'progress', 'searchcount' },
        -- lualine_y = {},
        -- lualine_z = { {} },

        -- lualine_y = { { 'tabs', show_modified_status = false, use_mode_colors = true } },
        -- lualine_z = {''},
      },
      -- winbar = { lualine_a = { 'searchcount' }, lualine_c = { '' }, lualine_y = { '' } },
      -- inactive_winbar = { lualine_a = {}, lualine_c = { 'diagnostics' } },
      extensions = { 'quickfix', 'trouble', 'neo-tree', 'symbols-outline', 'oil' },
    },

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
  },
}
