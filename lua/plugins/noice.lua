-- ============================================================================
-- Noice.nvim Configuration
-- Minimal UI - No animations
-- ============================================================================

vim.pack.add({
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
})

require('noice').setup({
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    hover = {
      enabled = true,
      silent = true, -- Don't show "No information available"
    },
    signature = { enabled = true },
  },
  presets = {
    bottom_search = true,
    command_palette = false,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
  routes = {
    -- Hide written/undo messages
    { filter = { event = 'msg_show', find = '%d+L, %d+B' }, opts = { skip = true } },
    { filter = { event = 'msg_show', find = '%d+ more lines?' }, opts = { skip = true } },
    { filter = { event = 'msg_show', find = '%d+ fewer lines?' }, opts = { skip = true } },
  },
  views = {
    mini = {
      win_options = { winblend = 0 },
    },
    hover = {
      border = {
        style = 'rounded',
        padding = { 1, 1 },
      },
      position = { row = 2, col = 2 },
      size = { max_width = 80, max_height = 25 },
    },
  },
  messages = {
    enabled = true,
    view = 'mini',
    view_error = 'mini',
    view_warn = 'mini',
  },
  notify = {
    enabled = true,
    view = 'mini',
  },
  popupmenu = {
    enabled = false,
  },
  cmdline = {
    enabled = true,
    view = 'cmdline',
  },
})

-- Replace vim.notify with noice's minimal notification
vim.notify = require('noice').notify
