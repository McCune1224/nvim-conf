-- Elixir LSP configuration
-- Requires: elixir-ls (installed via mason)

return {
  cmd = { 'elixir-ls' },
  filetypes = { 'elixir', 'eelixir', 'heex' },
  root_markers = { 'mix.exs', '.git' },
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = true,
      suggestSpecs = true,
      signatureAfterComplete = true,
    },
  },
}
