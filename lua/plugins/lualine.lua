return {
  { 'AndreM222/copilot-lualine' },
  {

    opts = {

      options = {
        -- theme = bubbles_theme,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        theme = 'no-clown-fiesta',
      },
      sections = {
        lualine_a = { 'mode', { 'filename', separator = { left = '' }, right_padding = 2, path = 1 } },
        lualine_b = { 'diagnostics', 'branch' },
        lualine_c = {
          '%=', --[[ add your center compoentnts here in place of this comment ]]
        },
        lualine_x = { 'copilot' },
        lualine_y = { 'quickfix', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'searchcount' },
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = { 'quickfix', 'neo-tree', 'symbols-outline', 'oil' },
    },

    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
