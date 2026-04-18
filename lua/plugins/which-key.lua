-- ============================================================================
-- Which-Key Configuration
-- Keymap hints and group labels
-- ============================================================================

vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

local ok, which_key = pcall(require, 'which-key')
if not ok then
  return
end

which_key.setup({
  preset = 'helix',
  delay = 300,
  filter = function(m) return m.desc and m.desc ~= '' end,
  spec = {
    { '<leader>b', group = '[B]uffer', icon = '󰓩 ' },
    { '<leader>c', group = '[C]ode / LSP', icon = '󰅩 ' },
    { '<leader>f', group = '[F]ind', icon = '󰈞 ' },
    { '<leader>g', group = '[G]it', icon = '󰊢 ' },
    { '<leader>gh', group = '[G]it [H]unk', icon = '󰊢 ' },
    { '<leader>h', group = '[H]arpoon', icon = '󰛢 ' },
    { '<leader>l', group = '[L]SP / [L]int', icon = '󰒋 ' },
    { '<leader>n', group = '[N]otifications', icon = '󰀪 ' },
    { '<leader>p', group = '[P]rogram / DAP', icon = '󰆈 ' },
    { '<leader>q', group = '[Q]uick session', icon = '󰍲 ' },
    { '<leader>s', group = '[S]wap', icon = '󰓡 ' },
    { '<leader>t', group = '[T]abs', icon = '󰓩 ' },
    { '<leader>u', group = '[U]I', icon = '󰔎 ' },
    { 'a', group = '[A]round (outer)', icon = '󰗧 ' },
    { 'i', group = '[I]nside (inner)', icon = '󰗧 ' },
    { 'g', group = '[G]oto', icon = '󰑮 ' },
    { '[', group = 'Previous', icon = '󰅂 ' },
    { ']', group = 'Next', icon = '󰅁 ' },
    { 'z', group = 'Fold', icon = '󰁂 ' },
  },
  win = {
    border = 'single',
    padding = { 1, 2 },
    wo = { winblend = 0 },
  },
  layout = {
    width = { min = 20, max = 50 },
    spacing = 4,
    align = 'left',
  },
  icons = {
    breadcrumb = '» ',
    separator = '➜ ',
    group = '+ ',
    ellipsis = '…',
    keys = {
      Space = 'SPC',
      Esc = 'ESC',
      CR = 'RET',
      Tab = 'TAB',
      BS = 'BS',
    },
  },
  sort = { 'manual', 'group', 'alphanum' },
  expand = 1,
})
