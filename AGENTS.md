# AGENTS.md - Neovim 0.12 Configuration Guide

## Overview

This guide assists with building a modern Neovim 0.12 configuration from scratch using:
- **vim.pack** - Built-in plugin manager (Neovim 0.12+)
- **vim.lsp.config/enable** - Native LSP configuration (no lspconfig needed)
- **mason.nvim** - For installing LSP servers (but NOT for configuring them)
- Minimal, integrated features over external plugins

## Legacy Configuration Reference

**Previous config location:** `~/.config/nvim.bkup/`

This folder contains the user's old Neovim configuration using lazy.nvim. Reference this when:
- Migrating plugins from the old setup
- Looking for specific plugin configurations (snacks, blink, harpoon, etc.)
- Checking previous keymaps or settings
- Understanding user's workflow preferences

**Note:** The new config (`~/.config/nvim/`) is a fresh start using vim.pack and native LSP. Do not automatically port everything from nvim.bkup - only migrate specific plugins or configs when explicitly requested.

## Key Principles

1. Use `vim.pack` for plugin management (no lazy.nvim/packer)
2. Use `vim.lsp.config()` + `vim.lsp.enable()` for LSP (no lspconfig)
3. Use mason ONLY for installing LSP binaries, not for configuration
4. Keep it simple - minimal plugins, maximum built-in features
5. **Use Nerd Font glyphs, NOT emojis** - Cool icons like `󰊢` `●` `󰌾` are fine, but no actual emojis like 😀 🎉

## Documentation Sources

Always check latest docs:
- `:help news` - Neovim 0.12 changes
- `:help vim.pack` - Plugin manager
- `:help lsp` - LSP configuration
- `:help mason.nvim` - LSP installer

## Quick Reference

### vim.pack

```lua
-- Add plugins
vim.pack.add({
  'https://github.com/user/repo',
  { src = 'https://github.com/user/repo', version = 'v1.0' },
})

-- Update
vim.pack.update()

-- Remove
vim.pack.del({ 'repo' })
```

### LSP Configuration

```lua
-- Global defaults
vim.lsp.config('*', {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Server config
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod', '.git' },
})

-- Enable
vim.lsp.enable('gopls')
```

### File Structure

```
~/.config/nvim/
├── init.lua              # Main entry point
├── nvim-pack-lock.json   # Plugin versions (commit this)
├── lua/
│   ├── config/
│   │   ├── options.lua   # vim.opt settings
│   │   ├── keymaps.lua   # Key mappings
│   │   ├── autocmds.lua  # Autocommands
│   │   └── lsp.lua       # Centralized LSP setup
│   └── plugins/
│       ├── mason.lua     # LSP installer
│       ├── treesitter.lua # Syntax highlighting
│       ├── mini.lua      # Utility modules
│       ├── snacks.lua    # Picker, terminal, git
│       ├── harpoon.lua   # File marks
│       ├── blink.lua     # Completion
│       └── colorschemes.lua # Theme collection
└── lsp/                  # LSP server configs
    ├── gopls.lua
    └── lua_ls.lua
```

## Go Development Setup

Minimal Go setup with native LSP:

```lua
-- Install gopls via mason, configure via vim.lsp.config
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.work', '.git' },
  settings = {
    gopls = {
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

vim.lsp.enable('gopls')
```

## Recommended Minimal Plugins

```lua
vim.pack.add({
  -- LSP installer (only for installing binaries)
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  
  -- Treesitter (syntax highlighting)
  'https://github.com/nvim-treesitter/nvim-treesitter',
  
  -- Mini.nvim (replaces many small plugins)
  'https://github.com/echasnovski/mini.nvim',
})
```

## Health Checks

```vim
:checkhealth vim.pack
:checkhealth vim.lsp
:checkhealth mason
:Mason
```

## Migration Notes

- mason-lspconfig is used ONLY for ensuring LSPs are installed
- Configuration is done via vim.lsp.config, NOT mason-lspconfig setup_handlers
- No need for nvim-lspconfig plugin anymore
- Each plugin file handles its own `vim.pack.add()` - install and config are co-located
- Plugins in `lua/plugins/` are self-contained modules

---

Last updated: Neovim 0.12-dev

---

Last updated: Neovim 0.12-dev
