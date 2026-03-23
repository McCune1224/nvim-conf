-- ============================================================================
-- conform.nvim Configuration
-- Fast, async formatting with LSP fallback
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

local conform = require('conform')

conform.setup({
  -- Formatter configuration by filetype
  formatters_by_ft = {
    -- Go
    go = { 'gofumpt', 'goimports' },
    -- Lua
    lua = { 'stylua' },
    -- Rust
    rust = { 'rustfmt' },
    -- JavaScript/TypeScript
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    -- JSON
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    -- CSS/HTML
    css = { 'prettierd', 'prettier', stop_after_first = true },
    scss = { 'prettierd', 'prettier', stop_after_first = true },
    html = { 'prettierd', 'prettier', stop_after_first = true },
    -- Markdown
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    -- YAML
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    -- TOML
    toml = { 'taplo' },
    -- C/C++
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    -- Python
    python = { 'black' },
    -- Elixir
    elixir = { 'mix' },
    -- Svelte
    svelte = { 'prettierd', 'prettier', stop_after_first = true },
    -- Templ
    templ = { 'templ' },
    -- Shell
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
  },

  -- Formatter options
  formatters = {
    stylua = {
      prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
    },
    shfmt = {
      prepend_args = { '-i', '2', '-ci' },
    },
  },

  -- Format on save is disabled by default (enable with :FormatEnable)
  format_on_save = function(bufnr)
    -- Only format if explicitly enabled
    if vim.g.enable_autoformat or vim.b[bufnr].enable_autoformat then
      return { timeout_ms = 500, lsp_fallback = true }
    end
    return nil
  end,

  -- Notify when no formatter is available
  notify_on_error = true,
  notify_no_formatters = true,
})

-- Commands to toggle format on save
vim.api.nvim_create_user_command('FormatEnable', function(args)
  if args.bang then
    -- FormatEnable! will enable for just this buffer
    vim.b.enable_autoformat = true
    vim.notify('Autoformat enabled for this buffer')
  else
    vim.g.enable_autoformat = true
    vim.notify('Autoformat enabled globally')
  end
end, {
  desc = 'Enable autoformat on save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.enable_autoformat = false
    vim.notify('Autoformat disabled for this buffer')
  else
    vim.g.enable_autoformat = false
    vim.notify('Autoformat disabled globally')
  end
end, {
  desc = 'Disable autoformat on save',
  bang = true,
})

-- Manual format keymap
vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = '[L]SP [F]ormat' })

-- Show format info
vim.keymap.set('n', '<leader>lF', function()
  conform.formatters_info()
end, { desc = '[L]SP [F]ormat info' })


-- Manual format keymap
vim.keymap.set({ 'n', 'v' }, '<C-f>', function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = '[L]SP [F]ormat' })
