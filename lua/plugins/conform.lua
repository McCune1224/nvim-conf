return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<C-f>',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      desc = ' [F]ormat',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {

      -- {lsp_format}
      --     `"never"`    never use the LSP for formatting (default)
      --     `"fallback"` LSP formatting is used when no other formatters are available
      --     `"prefer"`   use only LSP formatting when available
      --     `"first"`    LSP formatting is used when available and then other formatters
      --     `"last"`     other formatters are used then LSP formatting when
      lua = { 'stylua', lsp_format = 'fallback' },
      templ = { 'templ', lsp_format = 'fallback' },
      -- python = { 'isort', 'black', lsp_format = 'fallback' },
      go = { 'goimports', lsp_format = 'last' },
      sql = { 'sql-formatter', 'sqlfmt', stop_after_first = true, lsp_format = 'fallback' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'first' },
    },
  },
}

-- return {
--   { -- Autoformat
--     'stevearc/conform.nvim',
--     lazy = false,
--     keys = {
--       {
--         -- '<leader>F',
--         '<C-f>',
--         function()
--           require('conform').format { async = true, lsp_fallback = true }
--         end,
--         mode = '',
--         desc = '[F]ormat',
--       },
--     },
--     opts = {
--       notify_on_error = false,
--       format_on_save = function(bufnr)
--         -- Disable "format_on_save lsp_fallback" for languages that don't
--         -- have a well standardized coding style. You can add additional
--         -- languages here or re-enable it for the disabled ones.
--         local disable_filetypes = { c = true, cpp = true }
--         return {
--           timeout_ms = 500,
--           lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
--         }
--       end,
--       formatters_by_ft = {
--         lua = { 'stylua' },
--         -- Conform can also run multiple formatters sequentially
--         python = { 'isort', 'black' },
--         templ = { 'templ' },
--         html = { 'prettierd', 'prettier' },
--         --
--         -- You can use a sub-list to tell conform to run *until* a formatter
--         -- is found.
--         javascript = { 'prettierd', 'prettier', stop_after_first = true },
--         typescript = { 'prettierd', 'prettier', stop_after_first = true },
--       },
--     },
--   },
-- }
-- vim: ts=2 sts=2 sw=2 et
--
