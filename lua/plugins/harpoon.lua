return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    local map = vim.keymap

    map.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon [A]dd file' })

    map.set('n', '<leader>hr', function()
      harpoon:list():remove()
    end, { desc = '[H]arpoon [R]emove file' })

    map.set('n', '<leader>ht', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon [T]oggle menu' })

    for i = 1, 4 do
      map.set('n', '<leader>h' .. i, function()
        harpoon:list():select(i)
      end, { desc = '[H]arpoon jump to mark ' .. i })
    end
  end,
}
