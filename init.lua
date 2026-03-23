-- init.lua - Main entry point
-- Leader keys must be set before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load plugins
require 'plugins.mason'
require 'plugins.treesitter'
require 'plugins.mini'
require 'plugins.noice'
require 'plugins.snacks'
require 'plugins.harpoon'
require 'plugins.blink'
require 'plugins.oil'
require 'plugins.dap'
require 'plugins.render-markdown'
require 'plugins.dadbod'
require 'plugins.conform'
require 'plugins.nvim-lint'
require 'plugins.persistence'
require 'plugins.colorschemes'
require 'plugins.gitsigns'
require 'plugins.lualine'
require 'plugins.which-key'

-- LSP setup
require('config.lsp').setup_global_defaults()
vim.lsp.enable {
  'gopls',
  'lua_ls',
  'rust_analyzer',
  'clangd',
  'vtsls',
  'elixirls',
  'omnisharp',
  'tailwindcss',
  'templ',
  'svelte',
}

-- Load core config
require 'config.options'
require 'config.diagnostics'
require 'config.keymaps'
require 'config.autocmds'
require('config.tabs').setup()

-- Health check commands:
-- :checkhealth vim.pack
-- :checkhealth vim.lsp
-- :checkhealth mason
-- :Mason
