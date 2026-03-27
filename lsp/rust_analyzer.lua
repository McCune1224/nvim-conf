-- Rust LSP configuration
-- nvim-lspconfig provides defaults; this adds Rust-specific settings

return {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      checkOnSave = {
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      procMacro = {
        enable = true,
      },
      imports = {
        granularity = {
          group = 'module',
        },
        prefix = 'self',
      },
    },
  },
}
