return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = true,
  opts = {
    size = 20 or function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-/>]],
    shade_terminals = true,
  },
}
