-- Elixir LSP configuration
-- nvim-lspconfig provides defaults; this adds dialyzer and specs settings

return {
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps = true,
      suggestSpecs = true,
      signatureAfterComplete = true,
    },
  },
}
