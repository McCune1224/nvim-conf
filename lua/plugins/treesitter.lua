-- ============================================================================
-- Treesitter Configuration (nvim-treesitter main branch)
-- ============================================================================
-- NOTE: This is using the NEW main branch API, not the legacy master branch
-- See: https://github.com/nvim-treesitter/nvim-treesitter

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
}

-- Setup nvim-treesitter (optional, defaults work fine)
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath 'data' .. '/site',
}

-- ============================================================================
-- Enable Treesitter Features for All Filetypes
-- ============================================================================

-- Enable highlighting and indentation for any filetype that has a parser
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local ft = args.match
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    -- Check if parser exists for this language
    local ok = pcall(vim.treesitter.language.inspect, lang)
    if not ok then
      return
    end

    -- Enable syntax highlighting (built into Neovim)
    vim.treesitter.start()

    -- Enable treesitter-based indentation (provided by nvim-treesitter)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- ============================================================================
-- Parsers to Install (Stable Tier)
-- ============================================================================

-- Install all stable parsers on startup if not already installed
vim.defer_fn(function()
  local ts = require 'nvim-treesitter'
  local installed = ts.get_installed()

  if #installed == 0 then
    vim.notify('Installing all stable treesitter parsers...', vim.log.levels.INFO)
    ts.install 'stable'
  end
end, 100)

-- ============================================================================
-- Text Objects Configuration
-- ============================================================================

-- Text objects are configured via the legacy configs API for now
-- This may change in future nvim-treesitter-textobjects updates
vim.defer_fn(function()
  local ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not ok then
    return
  end

  configs.setup {
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ag'] = '@comment.outer',
          ['ig'] = '@comment.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']f'] = '@function.outer',
          [']a'] = '@parameter.outer',
          [']c'] = '@class.outer',
          [']v'] = '@variable.outer',
          [']i'] = '@loop.*',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']A'] = '@parameter.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[a'] = '@parameter.outer',
          ['[c'] = '@class.outer',
          ['[v'] = '@variable.outer',
          ['[i'] = '@loop.*',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[A'] = '@parameter.outer',
        },
      },
    },
  }
end, 0)

-- ============================================================================
-- Commands
-- ============================================================================

-- Command to install all stable parsers
vim.api.nvim_create_user_command('TSInstallAll', function()
  local ts = require 'nvim-treesitter'
  vim.notify('Installing all stable parsers...', vim.log.levels.INFO)
  ts.install 'stable'
end, { desc = 'Install all stable treesitter parsers' })

-- Command to update all parsers
vim.api.nvim_create_user_command('TSUpdateAll', function()
  local ts = require 'nvim-treesitter'
  vim.notify('Updating all parsers...', vim.log.levels.INFO)
  ts.update()
end, { desc = 'Update all treesitter parsers' })

-- ============================================================================
-- Health Check Command
-- ============================================================================

vim.api.nvim_create_user_command('TSHealth', function()
  vim.cmd 'checkhealth nvim-treesitter'
end, { desc = 'Check nvim-treesitter health' })
