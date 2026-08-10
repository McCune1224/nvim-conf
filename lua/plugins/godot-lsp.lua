-- ============================================================================
-- Godot LSP Configuration
-- Connects to Godot's built-in LSP server for GDScript completion & diagnostics
-- Godot must be running with LSP enabled (default: port 6005)
-- ============================================================================

-- Install plugin
vim.pack.add { 'https://github.com/dpowling/godot-lsp.nvim' }

local ok, godot_lsp = pcall(require, 'godot-lsp')
if not ok then
  vim.notify('godot-lsp.nvim failed to load - plugin may need installation or restart', vim.log.levels.WARN)
  return
end

godot_lsp.setup({
  port = 6005,           -- Godot's default LSP port
  fallback_port = 6006,  -- Fallback if primary port is in use
  auto_start = true,     -- Auto-connect when opening .gd files in a Godot project
  debug = false,         -- Set to true for troubleshooting
  silent = true,         -- Only show error messages
})
