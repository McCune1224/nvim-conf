vim.filetype.add {
  extension = {
    ino = 'arduino',
  },
}

-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--   pattern = '*.ino',
--   callback = function()
--     vim.bo.filetype = 'cpp'
--   end,
-- })
