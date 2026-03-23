-- gitsigns.lua - Git signs/status

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then return end

gitsigns.setup {
  signcolumn = false,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { follow_files = true },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  max_file_length = 40000,
  preview_config = {
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  update_debounce = 100,
  
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then vim.cmd.normal { ']c', bang = true }
      else gs.nav_hunk('next') end
    end, { buffer = bufnr, desc = 'Next git [C]hange' })
    
    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then vim.cmd.normal { '[c', bang = true }
      else gs.nav_hunk('prev') end
    end, { buffer = bufnr, desc = 'Prev git [C]hange' })
    
    vim.keymap.set('n', '<leader>ghs', gs.stage_hunk, { buffer = bufnr, desc = '[G]it [H]unk [S]tage' })
    vim.keymap.set('n', '<leader>ghr', gs.reset_hunk, { buffer = bufnr, desc = '[G]it [H]unk [R]eset' })
    vim.keymap.set('v', '<leader>ghs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { buffer = bufnr, desc = '[G]it [H]unk [S]tage' })
    vim.keymap.set('v', '<leader>ghr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { buffer = bufnr, desc = '[G]it [H]unk [R]eset' })
    vim.keymap.set('n', '<leader>ghS', gs.stage_buffer, { buffer = bufnr, desc = '[G]it [H]unk [S]tage buffer' })
    vim.keymap.set('n', '<leader>ghu', gs.undo_stage_hunk, { buffer = bufnr, desc = '[G]it [H]unk [U]ndo' })
    vim.keymap.set('n', '<leader>ghR', gs.reset_buffer, { buffer = bufnr, desc = '[G]it [H]unk [R]eset buffer' })
    vim.keymap.set('n', '<leader>ghp', gs.preview_hunk, { buffer = bufnr, desc = '[G]it [H]unk [P]review' })
    vim.keymap.set('n', '<leader>ghb', function() gs.blame_line { full = true } end, { buffer = bufnr, desc = '[G]it [H]unk [B]lame' })
    vim.keymap.set('n', '<leader>ghd', gs.diffthis, { buffer = bufnr, desc = '[G]it [H]unk [D]iff' })
    vim.keymap.set('n', '<leader>ghD', function() gs.diffthis '~' end, { buffer = bufnr, desc = '[G]it [H]unk [D]iff ~' })
    vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = '[T]oggle git [B]lame' })
    vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = '[T]oggle [D]eleted' })
  end,
}
