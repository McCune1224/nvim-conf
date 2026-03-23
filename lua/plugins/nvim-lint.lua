-- ============================================================================
-- nvim-lint Configuration
-- Async linting for all filetypes
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })

local lint = require('lint')

-- Configure linters by filetype
lint.linters_by_ft = {
  -- Go
  go = { 'golangcilint' },
  -- Lua
  lua = { 'luacheck' },
  -- JavaScript/TypeScript
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  -- Python
  python = { 'ruff', 'pylint' },
  -- Shell
  sh = { 'shellcheck' },
  bash = { 'shellcheck' },
  zsh = { 'shellcheck' },
  -- Markdown
  markdown = { 'markdownlint' },
  -- Dockerfile
  dockerfile = { 'hadolint' },
  -- YAML
  yaml = { 'yamllint' },
  -- Vim
  vim = { 'vint' },
  -- C/C++
  c = { 'clangtidy' },
  cpp = { 'clangtidy' },
}

-- Trigger linting on these events (disabled by default)
local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

-- Auto-linting is disabled by default - use :Lint to manually trigger
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
--   group = lint_augroup,
--   callback = function()
--     -- Only lint if the buffer has a filetype configured
--     local ft = vim.bo.filetype
--     if lint.linters_by_ft[ft] then
--       lint.try_lint()
--     end
--   end,
-- })

-- Manual lint command
vim.api.nvim_create_user_command('Lint', function()
  lint.try_lint()
end, { desc = 'Trigger linting for current buffer' })

-- Toggle auto-lint keymap
vim.keymap.set('n', '<leader>lt', function()
  local aug = vim.api.nvim_get_autocmds({ group = 'lint' })
  if #aug > 0 then
    vim.api.nvim_clear_autocmds({ group = 'lint' })
    vim.notify('Auto-linting disabled')
  else
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] then
          lint.try_lint()
        end
      end,
    })
    vim.notify('Auto-linting enabled')
  end
end, { desc = '[L]SP [T]oggle linting' })

-- Show available linters for current filetype
vim.keymap.set('n', '<leader>lL', function()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft]
  if linters then
    vim.notify('Linters for ' .. ft .. ': ' .. table.concat(linters, ', '))
  else
    vim.notify('No linters configured for ' .. ft)
  end
end, { desc = '[L]SP [L]inters info' })
