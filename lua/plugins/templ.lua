-- https://templ.guide/commands-and-tools/ide-support/#neovim--050
-- Templ for whatever reason doesn't play with NIX install so need to hard define the file type here for LSP to recognize
return {
  vim.filetype.add { extension = { templ = 'templ' } },
}
