return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below

    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- indent = { enabled = true },
    input = { enabled = true },
    image = { enabled = true },
    -- notifier = { enabled = true },
    layout = { enabled = true },
    quickfile = { enabled = true },
    -- scroll = { enabled = true },
    scratch = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,
      layout = {
        preset = 'top',
        -- preset = 'ivy_split',
      },
    },
    -- toggle = { enabled = true, which_key = true },
    -- zen = { enabled = true },
  },
  keys = {
    -- Scratchpad

    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },

    -- PICKER

    {
      '<leader><leader>',
      function()
        Snacks.picker.smart()
      end,
      desc = "'Smart' File Picker",
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.files {
          cwd = vim.fn.getcwd(),
        }
      end,
      desc = '[F]ind [F]ile (Workspace)',
    },
    {
      '<leader>fF',
      function()
        Snacks.picker.files {
          cwd = vim.fn.expand '%:p:h',
        }
      end,
      desc = '[F]ind [F]ile (cwd)',
    },
    {
      '<leader>fs',
      function()
        Snacks.picker.files {
          cwd = vim.fn.stdpath 'config',
        }
      end,
      desc = '[F]ind [S]ettings',
    },
    -- {
    --   '<leader>e',
    --   function()
    --     Snacks.picker.explorer {
    --       layout = { layout = { position = 'right' } },
    --     }
    --   end,
    --   desc = 'Filetree [E]xplorer',
    -- },
    {
      '<leader>,',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[,] Buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = '[/] Grep',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[F]ind [G]rep Buffers',
    },
    {
      '<leader>ft',
      function()
        Snacks.picker.treesitter()
      end,
      desc = '[F]ind [T]reesitter',
    },

    {
      '<leader>fi',
      function()
        Snacks.picker.icons()
      end,
      desc = '[F]ind [I]cons',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[:] Command History',
    },
    {
      '<leader>fq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[F]ind [Q]uickfix',
    },
    {
      '<leader>f"',
      function()
        Snacks.picker.registers()
      end,
      desc = '[F]ind ["]Registers',
    },
    {
      '<leader>fa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = '[F]ind [A]utocmd',
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.command_history()
      end,
      desc = '[F]ind [H]istory',
    },
    {
      '<leader>fC',
      function()
        Snacks.picker.commands()
      end,
      desc = '[F]ind [C]ommands',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = '[F]ind [D]iagnostics (buffer only)',
    },
    {
      '<leader>fD',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[F]ind [D]iagnostics',
    },
    {
      '<leader>fH',
      function()
        Snacks.picker.help()
      end,
      desc = '[F]ind [H]elp Page',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.cliphist()
      end,
      desc = '[F]ind Clipboard [H]istory',
    },
    {
      '<leader>fj',
      function()
        Snacks.picker.jumps()
      end,
      desc = '[F]ind [J]umps',
    },
    {
      '<leader>fk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[F]ind [K]eymaps',
    },
    {
      '<leader>fl',
      function()
        Snacks.picker.loclist()
      end,
      desc = '[F]ind Location List',
    },
    {
      '<leader>fM',
      function()
        Snacks.picker.man()
      end,
      desc = '[F]ind [M]an',
    },
    {
      '<leader>fm',
      function()
        Snacks.picker.marks()
      end,
      desc = '[F]ind [M]arks',
    },
    {
      '<leader>fR',
      function()
        Snacks.picker.resume()
      end,
      desc = '[F]ind [R]esume',
    },
    {
      '<leader>fq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[F]ind [Q]uickfix',
    },
    {
      '<leader>fc',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = '[F]ind [C]olorscheme',
    },
    {
      '<leader>fd',
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = '[F]ind [D]ecalarations',
    },
    {
      '<leader>fD',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = '[F]ind [D]ecalarations',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[F]ind [W]ords',
    },

    -- Words
    {
      '<leader>]]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
  },
}
