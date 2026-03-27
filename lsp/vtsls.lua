-- TypeScript/JavaScript LSP configuration (vtsls)
-- nvim-lspconfig provides defaults; this adds inlay hints and preferences

return {
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
      },
      updateImportsOnFileMove = {
        enabled = 'always',
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
      },
    },
  },
}
