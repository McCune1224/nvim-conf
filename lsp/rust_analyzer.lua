-- Rust LSP configuration
-- Requires: rust-analyzer (installed via mason)

return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  workspace_required = true,
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
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
        ignored = {
          leptos_macro = { 'component' },
        },
      },
      imports = {
        granularity = {
          group = 'module',
        },
        prefix = 'self',
      },
      completion = {
        postfix = {
          enable = true,
        },
        autoimport = {
          enable = true,
        },
      },
      hover = {
        actions = {
          enable = true,
          run = {
            enable = true,
          },
          gotoTypeDef = {
            enable = true,
          },
        },
        links = {
          enable = true,
        },
      },
      lens = {
        enable = true,
        run = {
          enable = true,
        },
        debug = {
          enable = true,
        },
      },
    },
  },
}
