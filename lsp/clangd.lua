-- C/C++ LSP configuration
-- nvim-lspconfig provides defaults; this adds extra clangd args and capabilities

return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--completion-style=bundled',
    '--pch-storage=memory',
  },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
}
