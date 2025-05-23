return {
  {
    'sphamba/smear-cursor.nvim',
    enabled = vim.fn.has 'win32' == 0, -- disables on Windows
    opts = { -- Default  Range
    },
  },
}
