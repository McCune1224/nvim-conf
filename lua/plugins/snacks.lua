return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- @type snacks.Config
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
    lazygit = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,
      layout = {
        -- preset = 'top',
        -- preset = 'vscode',
        -- preset = 'dropdown',
        preset = 'ivy_split',
      },
      win = {
        input = {
          keys = {
            ['<c-d>'] = { 'delete', mode = { 'i', 'n' } },
            ['<c-a>'] = { 'add', mode = { 'i', 'n' } },
            ['<c-p>'] = { 'move_up', mode = { 'i', 'n' } },
            ['<c-n>'] = { 'move_down', mode = { 'i', 'n' } },
          },
        },
      },
      sources = {
        harpoon = {
          finder = function()
            local output = {}
            local ok, harpoon = pcall(require, 'harpoon')
            if not ok or not harpoon then
              return output
            end
            local list = harpoon:list()
            if not list or not list.items then
              return output
            end
            for idx, item in ipairs(list.items) do
              if item and item.value and item.value:match '%S' then
                local row = item.context and item.context.row or 1
                local col = item.context and item.context.col or 1
                table.insert(output, {
                  text = item.value,
                  file = item.value,
                  index = idx,
                  row = row,
                  col = col,
                })
              end
            end
            return output
          end,
          format = function(item, picker)
            local filename = vim.fn.fnamemodify(item.file, ':t')
            local icon, icon_hl = Snacks.util.icon(filename, "file", {
              fallback = { file = "󰈔 " }
            })
            local dir = vim.fn.fnamemodify(item.file, ':h')
            if dir == '.' then
              dir = ''
            else
              dir = dir .. '/'
            end
            return {
              { tostring(item.index), 'SnacksPickerIcon' },
              { ' ' .. icon, icon_hl or 'SnacksPickerIcon' },
              { ' ' .. filename, 'SnacksPickerFile' },
              { ' ', 'SnacksPickerBorder' },
              { dir, 'SnacksPickerComment' },
              { ':', 'SnacksPickerDelim' },
              { tostring(item.row), 'SnacksPickerRow' },
              { ':', 'SnacksPickerDelim' },
              { tostring(item.col), 'SnacksPickerCol' },
            }
          end,
          preview = function(ctx)
            if Snacks.picker.util.path(ctx.item) then
              return Snacks.picker.preview.file(ctx)
            else
              return Snacks.picker.preview.none(ctx)
            end
          end,
          confirm = 'jump',
          opts = {
            multi = {
              enable = true,
            },
          },
          actions = {
            delete = function(picker, item)
              local ok, harpoon = pcall(require, 'harpoon')
              if not ok or not harpoon then
                return
              end
              local list = harpoon:list()
              if not list then
                return
              end
              local idx = item.index
              if idx then
                list:remove(idx)
              end
              picker:find()
            end,
            add = function(picker)
              picker:close()
              local ok, harpoon = pcall(require, 'harpoon')
              if ok and harpoon then
                harpoon:list():add()
              end
            end,
            move_up = function(picker, item)
              local ok, harpoon = pcall(require, 'harpoon')
              if not ok or not harpoon then
                return
              end
              local list = harpoon:list()
              if not list then
                return
              end
              local idx = item.index
              if idx and idx > 1 then
                list:move_up(idx)
              end
              picker:find()
            end,
            move_down = function(picker, item)
              local ok, harpoon = pcall(require, 'harpoon')
              if not ok or not harpoon then
                return
              end
              local list = harpoon:list()
              if not list then
                return
              end
              local idx = item.index
              if idx then
                list:move_down(idx)
              end
              picker:find()
            end,
          },
        },
      },
    },
    terminal = { enabled = true },
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
      '<leader>fG',
      function()
        Snacks.picker.grep_buffer()
      end,
      desc = '[F]ind [G]rep Current Buffer',
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
      '<leader>fe',
      function()
        Snacks.picker.diagnostics_buffer { severity = vim.diagnostic.severity.ERROR }
      end,
      desc = '[F]ind diagnostic [E]rrors (buffer only)',
    },
    {
      '<leader>fE',
      function()
        Snacks.picker.diagnostics { severity = vim.diagnostic.severity.ERROR }
      end,
      desc = '[F]ind diagnostic [E]rrors',
    },
    {
      '<leader>fE',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[F]ind diagnostic [E]rrors',
    },
    {
      '<leader>fH',
      function()
        Snacks.picker.help()
      end,
      desc = '[F]ind [H]elp Page',
    },
    -- {
    --   '<leader>fh',
    --   function()
    --     Snacks.picker.cliphist()
    --   end,
    --   desc = '[F]ind Clipboard [H]istory',
    -- },
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
      desc = '[F]ind [D]efinition',
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
    -- Lazygit
    {
      '<leader>gg',
      function()
        Snacks.lazygit.open()
      end,
      desc = 'Open Lazygit',
      mode = { 'n', 't' },
    },

    -- Git
    {
      '<leader>gf',
      function()
        Snacks.picker.git_files()
      end,
      desc = '[G]it [F]iles',
    },
    {
      '<leader>gb',
      function()
        Snacks.picker.git_branches()
      end,
      desc = '[G]it [B]ranches',
    },
    {
      '<leader>gl',
      function()
        Snacks.picker.git_log()
      end,
      desc = '[G]it [L]og',
    },
    {
      '<leader>gL',
      function()
        Snacks.picker.git_log_line()
      end,
      desc = '[G]it [L]og (line)',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = '[G]it [S]tatus',
    },
    {
      '<leader>gS',
      function()
        Snacks.picker.git_stash()
      end,
      desc = '[G]it [S]tash',
    },

    -- Harpoon
    {
      '<leader>hh',
      function()
        Snacks.picker.pick 'harpoon'
      end,
      desc = '[H]arpoon [H]arks (Snacks)',
    },
    {
      '<C-t>',
      function()
        Snacks.terminal.toggle()
      end,
      desc = 'Toggle Terminal',
      mode = { 'n', 't' },
    },
  },
}
