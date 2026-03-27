-- ============================================================================
-- Snacks.nvim Configuration
-- File picker, terminal, git, scratch, and more
-- ============================================================================

-- Install plugin
vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

local Snacks = require('snacks')

Snacks.setup({
  input = { enabled = true },
  image = { enabled = true },
  layout = { enabled = true },
  quickfile = { enabled = true },
  scratch = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  lazygit = { enabled = true },
  terminal = { enabled = true },
  picker = {
    enabled = true,
    ui_select = true,
    layout = {
      preset = 'ivy_split',
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
            if item and item.value and item.value:match('%S') then
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
          local icon, icon_hl = Snacks.util.icon(filename, 'file', {
            fallback = { file = '󰈔 ' },
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
          multi = { enable = true },
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
})

-- ============================================================================
-- KEYMAPS
-- ============================================================================

local map = vim.keymap.set

-- Scratchpad
map('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Toggle Scratch Buffer' })
map('n', '<leader>S', function() Snacks.scratch.select() end, { desc = 'Select Scratch Buffer' })

-- File pickers
map('n', '<leader><leader>', function() Snacks.picker.smart() end, { desc = "'Smart' File Picker" })
map('n', '<leader>ff', function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, { desc = '[F]ind [F]ile (Workspace)' })
map('n', '<leader>fF', function() Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') }) end, { desc = '[F]ind [F]ile (cwd)' })
map('n', '<leader>fs', function() Snacks.picker.files({ cwd = vim.fn.stdpath('config') }) end, { desc = '[F]ind [S]ettings' })
map('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = '[,] Buffers' })
map('n', '<leader>/', function() Snacks.picker.grep() end, { desc = '[/] Grep' })
map('n', '<leader>fw', function() Snacks.picker.grep_word() end, { desc = '[F]ind [W]ords' })

-- Search pickers
map('n', '<leader>fg', function() Snacks.picker.grep_buffers() end, { desc = '[F]ind [G]rep Buffers' })
map('n', '<leader>fG', function() Snacks.picker.grep_buffer() end, { desc = '[F]ind [G]rep Current Buffer' })
map('n', '<leader>ft', function() Snacks.picker.treesitter() end, { desc = '[F]ind [T]reesitter' })

-- Other pickers
map('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = '[:] Command History' })
map('n', '<leader>fq', function() Snacks.picker.qflist() end, { desc = '[F]ind [Q]uickfix' })
map('n', '<leader>f"', function() Snacks.picker.registers() end, { desc = '[F]ind [")Registers' })
map('n', '<leader>fk', function() Snacks.picker.keymaps() end, { desc = '[F]ind [K]eymaps' })
map('n', '<leader>fH', function() Snacks.picker.help() end, { desc = '[F]ind [H]elp Page' })
map('n', '<leader>fm', function() Snacks.picker.marks() end, { desc = '[F]ind [M]arks' })
map('n', '<leader>fR', function() Snacks.picker.resume() end, { desc = '[F]ind [R]esume' })
map('n', '<leader>uc', function() Snacks.picker.colorschemes() end, { desc = '[U]i [C]olorscheme' })

-- LSP pickers (using available keys: o, i, r, y)
map('n', '<leader>fo', function() Snacks.picker.lsp_symbols() end, { desc = '[F]ind Document Symbols' })
map('n', '<leader>fO', function() Snacks.picker.lsp_workspace_symbols() end, { desc = '[F]ind Workspace Symbols' })
map('n', '<leader>fi', function() Snacks.picker.lsp_implementations() end, { desc = '[F]ind [I]mplementations' })
map('n', '<leader>fy', function() Snacks.picker.lsp_type_definitions() end, { desc = '[F]ind T[y]pe Definitions' })
map('n', '<leader>fr', function() Snacks.picker.lsp_references() end, { desc = '[F]ind [R]eferences' })

-- Diagnostics
map('n', '<leader>fe', function() Snacks.picker.diagnostics_buffer({ severity = vim.diagnostic.severity.ERROR }) end, { desc = '[F]ind diagnostic [E]rrors (buffer only)' })
map('n', '<leader>fE', function() Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.ERROR }) end, { desc = '[F]ind diagnostic [E]rrors' })

-- Words (LSP references)
map('n', ']r', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Reference' })
map('n', '[r', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Reference' })

-- Git
map('n', '<leader>gg', function() Snacks.lazygit.open() end, { desc = 'Open Lazygit' })
map('n', '<leader>gf', function() Snacks.picker.git_files() end, { desc = '[G]it [F]iles' })
map('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = '[G]it [B]ranches' })
map('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = '[G]it [L]og' })
map('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = '[G]it [L]og (line)' })
map('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = '[G]it [S]tatus' })
map('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = '[G]it [S]tash' })

-- Harpoon picker
map('n', '<leader>hh', function() Snacks.picker.pick('harpoon') end, { desc = '[H]arpoon [H]arks (Snacks)' })

-- Terminal
map({ 'n', 't' }, '<C-t>', function() Snacks.terminal.toggle() end, { desc = 'Toggle Terminal' })
map( 'n', '<leader>uc', function() Snacks.picker.colorschemes() end, {desc = '[U]i [C]olorscheme'})
