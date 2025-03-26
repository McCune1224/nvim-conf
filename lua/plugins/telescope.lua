-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
--

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },

      -- Plugin for quick flie swapping / bookmarking
      { 'ThePrimeagen/harpoon', branch = 'harpoon2' },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      'nvim-tree/nvim-web-devicons',
      opts = {
        override = {
          go = { icon = '', color = '#73cadb', name = 'go' },
        },
        override_by_filename = {
          ['go.mod'] = { icon = '', color = '#73cadb', name = 'go' },
          ['go.sum'] = { icon = '', color = '#73cadb', name = 'go' },
        },
      },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   layout_strategy = 'vertical',
        --   layout_config = {
        --     height = vim.o.lines,
        --     width = vim.o.columns,
        --     prompt_position = 'bottom',
        --     preview_height = 0.4,
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      -- vim.keymap.set('n', '<leader>fh', builtin.help_tags(custom_theme(opts)), { desc = '[F]ind [H]elp' })
      -- vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      -- vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
      -- vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      -- vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      -- vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      -- vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
      -- vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = '[F]ind [C]olorscheme' })
      -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      -- vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = '[F] Find [S]ymbols' })
      -- vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, { desc = '[F] Find [S]ymbols' })

      local opts = {}
      local builtin = require 'telescope.builtin'
      local themes = require 'telescope.themes'
      local harpoon = require 'harpoon'
      local conf = require('telescope.config').values
      local function custom_theme(opts)
        opts = opts or {}

        local theme_opts = {
          theme = 'ivy',

          sorting_strategy = 'ascending',

          layout_strategy = 'vertical',
          layout_config = { height = 0.95 },
          -- layout_config = {
          --   height = vim.o.lines,
          --   width = math.floor(0.7 * vim.o.columns),
          --   prompt_position = 'bottom',
          --   preview_height = 0.7,
          -- },
        }
        return vim.tbl_deep_extend('force', theme_opts, opts)
      end

      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },

            layout_strategy = 'vertical',
            layout_config = {
              height = vim.o.lines,
              width = vim.o.columns,
              prompt_position = 'bottom',
              preview_height = 0.7,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>fh', function()
        toggle_telescope(harpoon:list())
      end, { desc = '[F]ind [H]arpoon' })

      -- vim.keymap.set('n', '<leader>fh', function()
      --   builtin.help_tags(custom_theme(opts))
      -- end, { desc = '[F]ind [H]elp' })

      -- vim.keymap.set('n', '<leader>fk', function()
      --   builtin.keymaps(custom_theme(opts))
      -- end, { desc = '[F]ind [K]eymaps' })
      --
      -- vim.keymap.set('n', '<leader>ff', function()
      --   builtin.find_files(custom_theme(opts))
      -- end, { desc = '[F]ind [F]iles' })
      --
      -- vim.keymap.set('n', '<leader>fs', function()
      --   builtin.builtin(custom_theme(opts))
      -- end, { desc = '[F]ind [S]elect Telescope' })
      --
      -- vim.keymap.set('n', '<leader>fw', function()
      --   builtin.diagnostics(custom_theme {
      --     prompt_title = 'Find Diagnostic Warnings',
      --     search = 'warning',
      --   })
      -- end, { desc = '[F]ind Diagnostic [W]arnings' })
      --
      -- vim.keymap.set('n', '<leader>fg', function()
      --   builtin.live_grep(custom_theme(opts))
      -- end, { desc = '[F]ind by [G]rep' })
      --
      -- vim.keymap.set('n', '<leader>fb', function()
      --   builtin.live_grep(custom_theme {
      --     grep_open_files = true,
      --   })
      -- end, { desc = '[F]ind Within [B]uffers' })
      --
      -- vim.keymap.set('n', '<leader>fd', function()
      --   builtin.diagnostics(custom_theme(opts))
      -- end, { desc = '[F]ind [D]iagnostics' })
      --
      -- vim.keymap.set('n', '<leader>fr', function()
      --   builtin.resume(custom_theme(opts))
      -- end, { desc = '[F]ind [R]esume' })
      --
      -- vim.keymap.set('n', '<leader>f.', function()
      --   builtin.oldfiles(custom_theme(opts))
      -- end, { desc = '[F]ind Recent Files ("." for repeat)' })
      --
      -- -- vim.keymap.set('n', '<leader>fc', function()
      -- --   builtin.colorscheme(custom_theme(opts))
      -- -- end, { desc = '[F]ind [C]olorscheme' })
      --
      -- vim.keymap.set('n', '<leader><leader>', function()
      --   builtin.buffers(custom_theme(opts))
      -- end, { desc = '[ ] Find existing buffers' })
      --
      -- vim.keymap.set('n', '<leader>fs', function()
      --   builtin.lsp_document_symbols(custom_theme(opts))
      -- end, { desc = '[F] Find [S]ymbols' })
      --
      -- vim.keymap.set('n', '<leader>fS', function()
      --   builtin.lsp_dynamic_workspace_symbols(custom_theme(opts))
      -- end, { desc = '[F] Find [S]ymbols' })
      --
      -- -- Slightly advanced example of overriding default behavior and theme
      -- -- vim.keymap.set('n', '<leader>/', function()
      -- --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      -- --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      -- --     winblend = 10,
      -- --     previewer = true,
      -- --   })
      -- -- end, { desc = '[/] Fuzzily search in current buffer' })
      --
      -- -- It's also possible to pass additional configuration options.
      -- --  See `:help telescope.builtin.live_grep()` for information about particular keys
      -- -- vim.keymap.set('n', '<leader>s/', function()
      -- --   builtin.live_grep {
      -- --     grep_open_files = true,
      -- --     prompt_title = 'Live Grep in Open Files',
      -- --   }
      -- -- end, { desc = '[S]earch [/] in Open Files' })
      --
      -- -- Shortcut for searching your Neovim configuration files
      -- vim.keymap.set('n', '<leader>sn', function()
      --   builtin.find_files(custom_theme { cwd = vim.fn.stdpath 'config' })
      -- end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
