return {
  { 'AndreM222/copilot-lualine' },
  {

    opts = {

      -- '█' '█'  -- solid blocks
      -- '▊' '▊'  -- partial blocks
      -- '▌' '▐'  -- half blocks
      options = {
        -- theme = bubbles_theme,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        -- component_separators = { left = '|', right = '|' },
        -- section_separators = { left = '', right = '' },
        -- sdfhklsf
        component_separators = { '' },
        -- component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },

        -- '█' '█'  -- solid blocks
        -- section_separators = { left = '█', right = '█' },
        -- section_separators = { left = '', right = '' },
        -- theme = 'no-clown-fiesta',
      },
      sections = {
        -- lualine_a = { 'mode', { 'filename', separator = { left = '' }, right_padding = 2, path = 1 } },
        lualine_a = { 'mode' },
        lualine_b = {

          'branch',
        },
        lualine_c = {
          { 'diagnostics' },
          '%=',
          { 'filename', path = 1 },
          { 'aerial' },
        },
        -- lualine_c = { "os.date('%a')", 'data', "require'lsp-status'.status()" }
        lualine_x = { 'copilot' },
        lualine_y = { 'trouble', 'progress' },
        lualine_z = {
          'location',
        },
      },
      -- inactive_sections = {
      --   -- lualine_a = { 'mode', { 'filename', separator = { left = '' }, right_padding = 2, path = 1 } },
      --   lualine_a = { 'filename' },
      --   lualine_b = { 'diagnostics', 'branch' },
      --   lualine_c = {
      --     '%=',
      --     { 'filename' },
      --     { 'aerial' } --[[ add your center compoentnts here in place of this comment ]],
      --   },
      --   -- lualine_c = { "os.date('%a')", 'data', "require'lsp-status'.status()" }
      --   lualine_x = {},
      --   lualine_y = { 'quickfix', 'progress' },
      --   lualine_z = {
      --     'location',
      --   },
      -- },
      tabline = {},
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
