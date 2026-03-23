-- keymaps.lua - Key bindings
-- Leader groups: b=buffer, c=code, f=find, g=git, h=harpoon, etc.

-- Movement - center screen after jumping
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '{', '{zz')
vim.keymap.set('n', '}', '}zz')
vim.keymap.set('n', 'G', 'Gzz')
vim.keymap.set('n', 'gg', 'ggzz')

-- Search - keep cursor centered, open folds
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search' })

-- Search word under cursor
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')

-- Jump list
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')

-- Bracket matching
vim.keymap.set('n', '%', '%zz')

-- Smart up/down for wrapped lines
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Resize windows
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>')

-- Buffer navigation
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>')
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<leader>bd', '<cmd>bp|bd #<cr>', { desc = '[B]uffer [d]elete (keep window)' })
vim.keymap.set('n', '<leader>bD', '<cmd>bd<cr>', { desc = '[B]uffer [D]elete (close window)' })

-- Tabs
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = '[T]ab [n]ew' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = '[T]ab [c]lose' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = '[T]ab [o]nly' })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Next tab' })
vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Prev tab' })

-- Quick tab access 1-9
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt', { desc = 'Tab ' .. i })
end

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]o to [D]efinition' })
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references({ includeDeclaration = false }) end, { desc = '[G]o to [R]eferences' })
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = '[G]o to [I]mplementation' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover docs' })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format() end, { desc = '[C]ode [F]ormat' })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  local next_diag = function(sev)
    vim.diagnostic.jump { count = 1, float = true, severity = sev }
  end
  local prev_diag = function(sev)
    vim.diagnostic.jump { count = -1, float = true, severity = sev }
  end
  severity = severity and vim.diagnostic.severity[severity] or nil
  if next then
    return function() next_diag(severity) end
  else
    return function() prev_diag(severity) end
  end
end

vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[C]ode [D]iagnostic' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next [D]iagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev [D]iagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next [E]rror' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev [E]rror' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next [W]arning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev [W]arning' })

-- LSP features
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = '[C]ode [L]ens' })
vim.keymap.set('n', '<leader>ih', function() require('config.lsp').toggle_inlay_hints() end, { desc = 'Toggle [I]nlay [H]ints' })

-- Quickfix navigation (wraps around)
vim.keymap.set('n', '[q', function()
  local qf = vim.fn.getqflist({ idx = 0, size = 0 })
  vim.cmd(qf.idx == 1 and 'clast' or 'cprev')
end, { desc = 'Prev [Q]uickfix' })

vim.keymap.set('n', ']q', function()
  local qf = vim.fn.getqflist({ idx = 0, size = 0 })
  vim.cmd(qf.idx == qf.size and 'cfirst' or 'cnext')
end, { desc = 'Next [Q]uickfix' })

-- Visual mode - stay in visual after indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move lines up/down
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==')
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==')
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi')
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi')
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv")

-- Files
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = '[S]ave' })
vim.keymap.set('n', '<leader>e', vim.cmd.Ex, { desc = '[E]xplorer' })
vim.keymap.set('n', '<leader>m', '<cmd>Mason<cr>', { desc = '[M]ason' })

-- Insert mode undo breakpoints
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' })

-- UI toggles
vim.keymap.set('n', '<leader>ut', function()
  vim.o.background = (vim.o.background == 'dark') and 'light' or 'dark'
end, { desc = '[U]I [T]oggle theme' })

vim.keymap.set('n', '<esc><esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear highlights' })

-- Disable Ctrl-Z (suspend)
vim.keymap.set('n', '<C-z>', '<Nop>')
vim.keymap.set('n', '<C-Z>', '<Nop>')
