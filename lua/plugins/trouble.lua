-- better diagnostics list and others
--
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  callback = function()
    vim.cmd [[Trouble qflist open]]
  end,
})
return {
  'folke/trouble.nvim',
  opts = {
    icons = {
      indent = {
        middle = ' ',
        last = ' ',
        top = ' ',
        ws = '│  ',
      },
    },
    modes = {
      mydiags = {
        mode = 'diagnostics', -- inherit from diagnostics mode
        filter = {
          any = {
            buf = 0, -- current buffer
            {
              severity = vim.diagnostic.severity.ERROR, -- errors only
              -- limit to files in the current project
              function(item)
                return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
              end,
            },
          },
        },
      },
    },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>tx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = '[T]oggle Diagnostics[X]',
    },
    {
      '<leader>tX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = '[T]oggle Diagnostics[X] (buffer)',
    },
    -- {
    --   '<leader>cs',
    --   '<cmd>Trouble symbols toggle focus=false<cr>',
    --   desc = 'Symbols (Trouble)',
    -- },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>tL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = '[T]oggle [L]oclist',
    },
    {
      '<leader>tQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = '[T]oggle [Q]uickfix',
    },
  },
}
