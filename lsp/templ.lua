-- Templ LSP configuration
-- Go HTML templating language
-- Requires: templ (installed via mason)

return {
  cmd = { 'templ', 'lsp' },
  filetypes = { 'templ' },
  root_markers = { 'go.mod', '.git' },
}
