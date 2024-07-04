-- better diagnostics list and others
return {
  'folke/trouble.nvim',
  cmd = { 'TroubleToggle', 'Trouble' },
  -- opts = { use_diagnostic_signs = true },
  opts = {},
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Document Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
    { '<leader>xL', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Defs (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist<cr>', desc = 'Quickfix List (Trouble)' },
    {
      '[q',
      function()
        if require('trouble').is_open() then
          require('trouble').previous { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Previous Trouble/Quickfix Item',
    },
    {
      ']q',
      function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Next Trouble/Quickfix Item',
    },
  },
}
