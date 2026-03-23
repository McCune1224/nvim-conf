vim.pack.add { 'https://github.com/lambdalisue/suda.vim' }

local ok_suda, suda = pcall(require, 'suda')
if not ok_suda then
  return
end

suda.setup {}
