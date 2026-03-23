-- ============================================================================
-- Render Markdown Configuration
-- Better markdown rendering
-- ============================================================================

-- Install plugin
vim.pack.add({
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
})

local ok_render, render = pcall(require, 'render-markdown')
if not ok_render then
  return
end

render.setup({
  file_types = { 'markdown', 'md', 'copilot-chat' },
  completions = { blink = { enabled = true } },
  render_modes = true,
})
