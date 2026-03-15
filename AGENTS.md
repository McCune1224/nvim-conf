# Neovim Lua Configuration - Agent Guide

## Quick Commands

```bash
# Format all Lua files
stylua .

# Check format without writing
stylua --check .

# Update Mason tools
nvim -c "MasonUpdate" -c "qa"

# Sync plugins
nvim -c "Lazy sync" -c "qa"

# Validate Lua syntax
lua -e "dofile('init.lua')"
```

## Code Style

### Formatting (StyLua)
- Indent: 2 spaces
- Quotes: Single preferred (`'string'`)
- Column width: 160
- Unix line endings
- Call parentheses: None for single string arg
- Run `stylua .` before committing

### Module Structure

```lua
-- Return table for lazy.nvim specs
return {
  'author/plugin-name',
  dependencies = { 'dep1', 'dep2' },
  opts = {}, -- or config = function() ... end
}
```

### Requires

Prefer space-separated for single modules:
```lua
require 'module'
```

Use parentheses when assigning:
```lua
local module = require('module')
```

### Comments

- Use `--` with space after
- Section headers: `-- [[ Section Name ]]`
- Inline comments after code, aligned when possible

```lua
-- Good comment
local x = 1 -- inline with space
```

### Naming Conventions

- Variables: `snake_case`
- Plugin specs: Match plugin name (e.g., `lspconfig.lua`)
- Local functions: `snake_case`
- Keymap descriptions: Use `[X]` pattern for leader keys

### Plugin Spec Patterns

Simple plugin:
```lua
return { 'user/plugin' }
```

With options:
```lua
return {
  'user/plugin',
  opts = { setting = true },
}
```

With config:
```lua
return {
  'user/plugin',
  config = function()
    require('plugin').setup {}
  end,
}
```

Conditional loading:
```lua
return {
  'user/plugin',
  lazy = false,
  priority = 1000,
  ft = 'lua',
  event = 'VeryLazy',
}
```

### Keymap Conventions

- Leader key: `<space>`
- Local leader: `,` (for grug-far)
- Pattern: `[X]escription` for leader commands

```lua
-- Leader mappings
vim.keymap.set('n', '<leader>ff', cmd, { desc = '[F]ind [F]iles' })

-- LSP mappings (buffer-local)
local map = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
end
map('gd', func, '[G]oto [D]efinition')
```

### Autocommands

```lua
vim.api.nvim_create_autocmd('Event', {
  desc = 'Human readable description',
  group = vim.api.nvim_create_augroup('groupname', { clear = true }),
  callback = function()
    -- logic
  end,
})
```

### File Organization

```
lua/
├── options.lua
├── keymaps.lua
├── lazy-bootstrap.lua
├── lazy-plugins.lua
├── ftdetect.lua
└── plugins/
    ├── colorscheme.lua
    ├── lspconfig.lua
    └── ...
```

### Modeline

All Lua files end with:
```lua
-- vim: ts=2 sts=2 sw=2 et
```

## Common Tasks

### Adding a New Plugin

1. Create file in `lua/plugins/<name>.lua`
2. Return plugin spec table
3. Run `:Lazy sync` in Neovim

### Adding LSP Server

1. Add to `servers` table in `lua/plugins/lspconfig.lua`
2. Run `:Mason` to install
3. Configure settings if needed

### Adding Keymaps

- Global: Add to `lua/keymaps.lua`
- Plugin-specific: Add in plugin's `config` function
- Buffer-local: Use `buffer = bufnr` option

## Validation Checklist

- [ ] `stylua .` passes
- [ ] Modeline present at EOF
- [ ] Plugin returns valid table
- [ ] Keymaps have descriptions
- [ ] No trailing whitespace
- [ ] Unix line endings (LF)
