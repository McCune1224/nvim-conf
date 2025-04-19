-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- https://github.com/MagicDuck/grug-far.nvim
vim.g.maplocalleader = ','

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', function()
--   vim.diagnostic.jump { count = -1, float = true }
-- end, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', function()
--   vim.diagnostic.jump { count = 1, float = true }
-- end, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = '[D]iagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = '[D]iagnostic quickfix [L]ist' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Enable auto format
vim.g.autoformat = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { 'lsp', { '.git', 'lua' }, 'cwd' }

-- Optionally setup the terminal to use
-- This sets `vim.o.shell` and does some additional configuration for:
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remap jumps to keep items centered

local keymap = vim.keymap.set

keymap('n', '<C-u>', '<C-u>zz') -- Page Scroll up + center screen
keymap('n', '<C-d>', '<C-d>zz') -- Page Scroll down + center screen
keymap('n', '{', '{zz') -- Scroll down a Paragraph + center screen
keymap('n', '}', '}zz') -- Scroll up a Paragraph + center screen
keymap('n', 'n', 'nzz') -- Next search result + center scree
keymap('n', 'N', 'Nzz') -- Previous search result + center scree

-- Center buffer while navigating
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '{', '{zz')
keymap('n', '}', '}zz')
keymap('n', 'N', 'Nzz')
keymap('n', 'n', 'nzz')
keymap('n', 'G', 'Gzz')
keymap('n', 'gg', 'ggzz')
keymap('n', '<C-i>', '<C-i>zz')
keymap('n', '<C-o>', '<C-o>zz')
keymap('n', '%', '%zz')
keymap('n', '*', '*zz')
keymap('n', '#', '#zz')

-- better up/down
keymap({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
keymap('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })

-- Resize window using <ctrl> arrow keys
keymap('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
keymap('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
keymap('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
keymap('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Move Lines
keymap('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move Down' })
keymap('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move Up' })
keymap('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
keymap('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
keymap('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move Down' })
keymap('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move Up' })

-- buffers (Turn off for now as using barbar.nvim)
-- keymap('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
-- keymap('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap('n', '<leader>bd', '<cmd>bp|bd #<cr>', { desc = 'Delete Buffer Keep Window' })
keymap('n', '<leader>bD', '<cmd>bd<cr>', { desc = 'Delete Buffer And Window' })
-- keymap('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
-- keymap('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
-- keymap('n', '<leader>bd', '<cmd>bp|bd #<cr>', { desc = 'Delete Buffer Keep Window' })
-- keymap('n', '<leader>bD', '<cmd>bd<cr>', { desc = 'Delete Buffer And Window' })

-- Tabs
keymap('n', '<leader>tc', '<cmd>tabnew<cr>', { desc = 'Tab Create' })
keymap('n', '<leader>th', '<cmd>tabprevious<cr>', { desc = 'Tab Previous' })
keymap('n', '<leader>tl', '<cmd>tabnext<cr>', { desc = 'Tab Next' })
keymap('n', '<leader>tj', '<cmd>tabfirst<cr>', { desc = 'Tab First' })
keymap('n', '<leader>tk', '<cmd>tablast<cr>', { desc = 'Tab Last' })

-- Clear search with <esc>
keymap({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch / Diff Update' })
keymap('n', '<leader><esc>', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch / Diff Update' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
keymap('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
keymap('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
keymap('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
keymap('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
keymap('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Add undo break-points
keymap('i', ',', ',<c-g>u')
keymap('i', '.', '.<c-g>u')
keymap('i', ';', ';<c-g>u')

-- save file
keymap({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

--keywordprg
-- keymap('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

-- better indenting
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- lazy
keymap('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- new file
keymap('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

-- Quickfix list
-- keymap('n', '<leader>xl', '<cmd>lopen<cr>', { desc = 'Location List' })
-- keymap('n', '<leader>xq', '<cmd>copen<cr>', { desc = 'Quickfix List' })

-- keymap('n', '<A-j>', vim.cmd.cnext, { desc = 'Next Quickfix' })
-- keymap('n', '<A-k>', vim.cmd.cprevious, { desc = 'Next Quickfix' })
keymap('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
keymap('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local next_diag = function(sev)
    vim.diagnostic.jump { count = 1, float = true, severity = sev }
  end
  local prev_diag = function(sev)
    vim.diagnostic.jump { count = -1, float = true, severity = sev }
  end
  -- local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  if next then
    return function()
      next_diag(severity)
    end
  else
    return function()
      prev_diag(severity)
    end
  end
end
keymap('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
keymap('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
keymap('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
keymap('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
keymap('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
keymap('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
keymap('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- stylua: ignore start

-- quit
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "[Q]uick [Q]uit" })

-- highlights under cursor
keymap("n", "<leader>ui", vim.show_pos, { desc = "[U]nder cursor [I]nspection (Treesitter)" })


-- windows
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
keymap("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })

-- -- tabs
-- keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- tabs
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })


-- [[ Plugin settings ]]
-- keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", {desc = "Open Neo-Tree"})

-- Map Oil to <leader>e
-- keymap("n", "<leader>e", function()
--   require("oil").toggle_float()
-- end)

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
