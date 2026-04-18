-- ============================================================================
-- Neovim 0.12 Configuration - Main Entry Point
-- ============================================================================
-- Uses vim.pack (built-in plugin manager) and native LSP (vim.lsp.config)
-- See AGENTS.md for configuration principles
--
-- Loading order:
--   1. Plugins (vim.pack.add)
--   2. LSP global defaults
--   3. Core configuration (options -> diagnostics -> keymaps -> autocmds -> tabs)
--
-- Health checks:
--   :checkhealth vim.pack
--   :checkhealth vim.lsp
--   :checkhealth mason
--   :Mason
-- ============================================================================

-- Leader keys must be set before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load plugins (order matters for dependencies)
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
require 'plugins.aerial'
require 'plugins.which-key'
require 'plugins.suda'

-- LSP setup (mason-lspconfig handles vim.lsp.enable() via automatic_enable)
require('config.lsp').setup_global_defaults()

-- Load core configuration
require 'config.options'
require 'config.diagnostics'
require 'config.keymaps'
require 'config.autocmds'
require('config.tabs').setup()
