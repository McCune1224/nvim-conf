-- Svelte LSP configuration
-- For SvelteKit and Svelte projects
-- Requires: svelte-language-server (installed via mason)

return {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = { 'svelte.config.js', 'svelte.config.ts', '.git' },
  settings = {
    svelte = {
      plugin = {
        html = {
          enable = true,
        },
        svelte = {
          enable = true,
        },
        css = {
          enable = true,
        },
        typescript = {
          enable = true,
          diagnostics = {
            enable = true,
          },
        },
      },
      compilerWarnings = {
        ['unused-export-let'] = 'ignore',
      },
    },
  },
}
