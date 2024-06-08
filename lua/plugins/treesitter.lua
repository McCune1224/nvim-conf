return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'c_sharp',
        'html',
        'css',
        'javascript',
        'typescript',
        'elixir',
        'python',
        'lua',
        'luadoc',
        'markdown',
        'vim',
        'vimdoc',
        'templ',
        'go',
        'rust',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      local configs = require 'nvim-treesitter.configs'
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
              ['aa'] = '@class.outer',
              ['ia'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']o'] = '@loop.*',
              [']]'] = '@class.outer',
              [']['] = '@parameter.outer',
              [']F'] = '@function.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']O'] = '@loop.*',
              [']['] = '@class.outer',
              [']]'] = '@variable.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[o'] = '@loop.*',
              ['[['] = '@class.outer',
              ['[]'] = '@parameter.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[O'] = '@loop.*',
              ['[]'] = '@class.outer',
            },
          },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
