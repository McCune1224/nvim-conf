-- ============================================================================
-- Render Markdown Configuration
-- Better markdown rendering for markdown files and LSP hover docs
-- ============================================================================

vim.pack.add({
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
})

local ok_render, render = pcall(require, 'render-markdown')
if not ok_render then
  return
end

render.setup({
  -- Render in all file types where markdown might appear
  file_types = { 'markdown', 'md', 'copilot-chat' },
  
  -- Enable for all modes (not just markdown files)
  render_modes = true,
  
  -- Completions integration
  completions = { blink = { enabled = true } },
  
  -- Override settings for specific buftypes (like LSP hover windows)
  overrides = {
    buftype = {
      nofile = {
        -- Enable rendering in nofile buffers (LSP hover, etc.)
        render_modes = true,
        -- Disable signs in hover docs
        sign = { enabled = false },
      },
    },
  },
})
