-- ============================================================================
-- Which-Key Configuration
-- Keymap hints and group labels
-- ============================================================================

vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

local ok_which_key, which_key = pcall(require, 'which-key')
if not ok_which_key then
  vim.notify('which-key.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

which_key.setup({
  preset = 'helix',
  delay = 300,
  filter = function(m) return m.desc and m.desc ~= '' end,
  spec = {
    -- Top-level groups
    { '<leader>a', group = '[A]erial', icon = '󰙅 ' },
    { '<leader>b', group = '[B]uffer', icon = '󰓩 ' },
    { '<leader>c', group = '[C]ode / LSP', icon = '󰅩 ' },
    { '<leader>d', group = '[D]atabase', icon = '󰆼 ' },
    { '<leader>f', group = '[F]ind', icon = '󰈞 ' },
    { '<leader>g', group = '[G]it', icon = '󰊢 ' },
    { '<leader>gh', group = '[G]it [H]unk', icon = '󰊢 ' },
    { '<leader>h', group = '[H]arpoon', icon = '󰛢 ' },
    { '<leader>l', group = '[L]SP / [L]int', icon = '󰒋 ' },
    { '<leader>m', group = '[M]ason', icon = '󰏗 ' },
    { '<leader>n', group = '[N]otifications', icon = '󰀪 ' },
    { '<leader>p', group = '[P]rogram / DAP', icon = '󰆈 ' },
    { '<leader>q', group = '[Q]uick session', icon = '󰍲 ' },
    { '<leader>s', group = '[S]wap', icon = '󰓡 ' },
    { '<leader>t', group = '[T]abs / [T]oggle', icon = '󰓩 ' },
    { '<leader>u', group = '[U]I', icon = '󰔎 ' },

    -- Text objects
    { 'a', group = '[A]round (outer)', icon = '󰗧 ' },
    { 'i', group = '[I]nside (inner)', icon = '󰗧 ' },

    -- Navigation
    { 'g', group = '[G]oto', icon = '󰑮 ' },
    { '[', group = 'Previous', icon = '󰅂 ' },
    { ']', group = 'Next', icon = '󰅁 ' },
    { 'z', group = 'Fold', icon = '󰁂 ' },

    -- Surround (mini.surround)
    { 's', group = '[S]urround', icon = '󰗧 ' },
    { 'sa', desc = 'Add surrounding', icon = '󰐝 ' },
    { 'sd', desc = 'Delete surrounding', icon = '󰩹 ' },
    { 'sr', desc = 'Replace surrounding', icon = '󰑕 ' },
    { 'sf', desc = 'Find right surrounding', icon = '󰑮 ' },
    { 'sF', desc = 'Find left surrounding', icon = '󰰌 ' },
    { 'sh', desc = 'Highlight surrounding', icon = '󰸱 ' },

    -- Mini.ai text objects
    { 'g[', desc = 'Move to left "around"', icon = '󰅂 ' },
    { 'g]', desc = 'Move to right "around"', icon = '󰅁 ' },

    -- Comments (mini.comment)
    { 'gc', desc = 'Comment', icon = '󰆄 ' },
    { 'gcc', desc = 'Comment line', icon = '󰆄 ' },

    -- Treesitter navigation sub-groups
    { '[a', desc = 'Previous argument', icon = '󰅂 ' },
    { '[b', desc = 'Previous block', icon = '󰅂 ' },
    { '[c', desc = 'Previous git change', icon = '󰅂 ' },
    { '[d', desc = 'Previous diagnostic', icon = '󰅂 ' },
    { '[e', desc = 'Previous error', icon = '󰅂 ' },
    { '[f', desc = 'Previous function', icon = '󰅂 ' },
    { '[l', desc = 'Previous loop', icon = '󰅂 ' },
    { '[q', desc = 'Previous quickfix', icon = '󰅂 ' },
    { '[r', desc = 'Previous reference', icon = '󰅂 ' },
    { '[w', desc = 'Previous warning', icon = '󰅂 ' },
    { ']a', desc = 'Next argument', icon = '󰅁 ' },
    { ']b', desc = 'Next block', icon = '󰅁 ' },
    { ']c', desc = 'Next git change', icon = '󰅁 ' },
    { ']d', desc = 'Next diagnostic', icon = '󰅁 ' },
    { ']e', desc = 'Next error', icon = '󰅁 ' },
    { ']f', desc = 'Next function', icon = '󰅁 ' },
    { ']l', desc = 'Next loop', icon = '󰅁 ' },
    { ']q', desc = 'Next quickfix', icon = '󰅁 ' },
    { ']r', desc = 'Next reference', icon = '󰅁 ' },
    { ']w', desc = 'Next warning', icon = '󰅁 ' },
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
