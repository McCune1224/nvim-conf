-- TypeScript/JavaScript LSP configuration
-- Uses vtsls - faster replacement for tsserver
-- Requires: vtsls (installed via mason: typescript-language-server)

return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
        autoImports = true,
      },
      updateImportsOnFileMove = {
        enabled = 'always',
      },
      preferences = {
        importModuleSpecifier = 'relative',
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      suggest = {
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
        autoImports = true,
      },
      updateImportsOnFileMove = {
        enabled = 'always',
      },
      preferences = {
        importModuleSpecifier = 'relative',
      },
    },
  },
}
