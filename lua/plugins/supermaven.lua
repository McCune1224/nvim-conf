return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      -- disable_inline_completion = true,
      disable_keymaps = true,
    }
    -- Disable supermaven by default
    -- local api = require 'supermaven-nvim.api'
    -- api.stop()
  end,
}
