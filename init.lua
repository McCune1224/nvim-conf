-- ============================================================================
-- Neovim 0.12 Minimal Configuration
-- Focus: Go development with native LSP
-- ============================================================================

-- Set leader key BEFORE loading any modules or plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ============================================================================
-- PLUGINS (each handles its own installation via vim.pack.add)
-- ============================================================================

-- Core plugins (load first)
require('plugins.mason')
require('plugins.treesitter')
require('plugins.mini')

-- Feature plugins
require('plugins.snacks')
require('plugins.harpoon')
require('plugins.blink')
require('plugins.oil')
require('plugins.dap')
require('plugins.render-markdown')
require('plugins.dadbod')

-- UI
require('plugins.colorschemes')
require('plugins.lualine')

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

require('config.lsp').setup_global_defaults()
vim.lsp.enable({
  'gopls',          -- Go
  'lua_ls',         -- Lua
  'rust_analyzer',  -- Rust
  'clangd',         -- C/C++
  'vtsls',          -- JavaScript/TypeScript
  'elixirls',       -- Elixir
  'omnisharp',      -- C#
  'tailwindcss',    -- TailwindCSS
  'templ',          -- Go Templating
  'svelte',         -- Svelte/SvelteKit
})

-- ============================================================================
-- LOAD CONFIGURATION MODULES
-- ============================================================================

require('config.options')
require('config.keymaps')
require('config.autocmds')

-- ============================================================================
-- HEALTH CHECK REMINDER
-- ============================================================================

-- Run these commands to verify setup:
-- :checkhealth vim.pack
-- :checkhealth vim.lsp
-- :checkhealth mason
-- :Mason
