-- C# LSP configuration (OmniSharp)
-- Requires: omnisharp (installed via mason)
-- Full-featured with Roslyn analyzers

return {
  cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
  filetypes = { 'cs', 'vb' },
  root_markers = { '*.sln', '*.csproj', '.git' },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
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
