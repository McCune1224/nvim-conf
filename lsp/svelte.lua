-- Svelte LSP configuration
-- nvim-lspconfig provides defaults; this adds SvelteKit-specific settings

return {
  settings = {
    svelte = {
      compilerWarnings = {
        ['unused-export-let'] = 'ignore',
      },
    },
  },
}
