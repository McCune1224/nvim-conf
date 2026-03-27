-- ============================================================================
-- Treesitter Configuration (legacy configs API - works properly)
-- ============================================================================

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'master' },
}

-- Setup using the legacy configs API (this is what your old config used)
local function setup()
  local ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not ok then
    return
  end

  configs.setup {
    -- Install parsers synchronously (only on demand)
    ensure_installed = {},
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },

    indent = {
      enable = true,
      disable = { 'ruby' },
    },

    -- Incremental selection
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<BS>',
      },
    },
  }

  -- Textobjects setup
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
end

-- Defer setup to ensure plugins are loaded
vim.defer_fn(setup, 0)

-- Command to install all parsers
vim.api.nvim_create_user_command('TSInstallAll', function()
  local ok, ts = pcall(require, 'nvim-treesitter')
  if ok then
    ts.install {
      'go', 'gomod', 'gowork', 'gosum', 'gotmpl',
      'lua', 'vim', 'vimdoc', 'query',
      'svelte', 'javascript', 'typescript', 'tsx', 'html', 'css', 'scss',
      'json', 'jsonc', 'yaml', 'toml', 'xml',
      'bash', 'fish',
      'markdown', 'markdown_inline',
      'regex', 'sql',
      'python', 'rust',
      'c', 'cpp', 'cmake',
    }
  else
    vim.notify('nvim-treesitter not loaded', vim.log.levels.ERROR)
  end
end, { desc = 'Install all treesitter parsers' })
