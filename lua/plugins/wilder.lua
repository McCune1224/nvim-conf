return {
  {
    'gelguy/wilder.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    },
    keys = {
      ':',
      '/',
      '?',
    },
    config = function()
      local wilder = require 'wilder'
      wilder.setup { modes = { ':', '/', '?' } }

      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline {
            fuzzy = 1,
          },
          wilder.vim_search_pipeline {
            fuzzy = 1,
          }
        ),
      })

      wilder.set_option(
        'renderer',
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
          pumblend = 5,
          min_width = '100%',
          min_height = '25%',
          max_height = '25%',
          border = 'rounded',
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() },
          -- highlighter = wilder.basic_highlighter(),
        })
      )
    end,
  },
}
