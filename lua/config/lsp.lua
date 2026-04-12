-- lsp.lua - LSP configuration

local M = {}

-- Border styles
M.border = {
  rounded = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  single = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  double = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  heavy = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
}

M.border_style = M.border.heavy

M.setup_highlights = function()
  local float_border = vim.api.nvim_get_hl(0, { name = 'FloatBorder' })
  if not float_border or vim.tbl_isempty(float_border) then
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'WinSeparator' })
  end

  local normal_float = vim.api.nvim_get_hl(0, { name = 'NormalFloat' })
  if not normal_float or vim.tbl_isempty(normal_float) then
    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
  end
end

-- Store last hover window for double-K focus
M.last_hover_win = nil

-- Check if hover is visible
M.is_hover_visible = function()
  return M.last_hover_win and vim.api.nvim_win_is_valid(M.last_hover_win)
end

-- Store last signature window for double-trigger focus
M.last_signature_win = nil

-- Check if signature help is visible
M.is_signature_visible = function()
  return M.last_signature_win and vim.api.nvim_win_is_valid(M.last_signature_win)
end

-- Open URL in browser
M.open_url = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Find URL
  local url = line:sub(col + 1):match('^https?://[^%s<>"]+')
    or line:sub(1, col + 1):match('https?://[^%s<>"]+$')

  if url then
    url = url:gsub('[.,;:!?]+$', '')
    local cmd = vim.fn.has('mac') == 1 and { 'open', url }
      or vim.fn.has('win32') == 1 and { 'cmd', '/c', 'start', url }
      or { 'xdg-open', url }
    vim.system(cmd)
    vim.notify('Opening: ' .. url)
  else
    vim.notify('No URL found', vim.log.levels.WARN)
  end
end

-- Fancy hover with double-K to focus
M.fancy_hover = function()
  -- Double-K: focus existing hover
  if M.is_hover_visible() then
    vim.api.nvim_set_current_win(M.last_hover_win)
    return
  end

  -- Get position params with encoding to avoid warning
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  local encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
  local params = vim.lsp.util.make_position_params(0, encoding)

  vim.lsp.buf_request(buf, 'textDocument/hover', params, function(err, result)
    if err or not result or not result.contents then
      return
    end

    local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    if vim.tbl_isempty(contents) then
      return
    end

    -- Strip markdown syntax
    contents = vim.tbl_map(function(line)
      -- Remove code block delimiters
      line = line:gsub('^%s*```[%w]*%s*$', '')
      -- Remove headers
      line = line:gsub('^%s*#+%s*', '')
      -- Remove inline code backticks (keep content)
      line = line:gsub('`([^`]+)`', '%1')
      -- Remove bold/italic markers
      line = line:gsub('%*%*([^*]+)%*%*', '%1') -- bold
      line = line:gsub('%*([^*]+)%*', '%1') -- italic
      line = line:gsub('_([^_]+)_', '%1') -- italic underscore
      return line
    end, contents)
    -- Remove empty lines from stripping
    contents = vim.tbl_filter(function(line) return line ~= '' end, contents)

    -- Create hover window
    local bufnr, winnr = vim.lsp.util.open_floating_preview(
      contents,
      'markdown',
      {
        border = M.border_style,
        max_width = 80,
        max_height = 20,
        focusable = true,
      }
    )

    if winnr then
      M.last_hover_win = winnr

      -- Enhancements
      vim.wo[winnr].conceallevel = 3
      vim.wo[winnr].concealcursor = 'nvc'
      vim.wo[winnr].wrap = true
      vim.wo[winnr].linebreak = true

      -- Treesitter highlighting if available
      if pcall(vim.treesitter.start, bufnr, 'markdown') then
        -- Success
      else
        vim.bo[bufnr].syntax = 'markdown'
      end

      -- Keymaps
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = bufnr, silent = true })
      vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = bufnr, silent = true })
      vim.keymap.set('n', 'gx', function() M.open_url() end, { buffer = bufnr, silent = true, desc = 'Open URL' })
    end
  end)
end

-- Fancy signature help with double-trigger to focus
M.fancy_signature = function()
  -- Double-trigger: focus existing signature window
  if M.is_signature_visible() then
    vim.api.nvim_set_current_win(M.last_signature_win)
    return
  end

  -- Get position params with encoding
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  local encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
  local params = vim.lsp.util.make_position_params(0, encoding)

  vim.lsp.buf_request(buf, 'textDocument/signatureHelp', params, function(err, result, ctx, config)
    if err or not result or not result.signatures then
      return
    end

    if vim.tbl_isempty(result.signatures) then
      return
    end

    -- Use Neovim 0.12's built-in signature help with custom config
    local _, winnr = vim.lsp.buf.signature_help({
      border = M.border_style,
      max_width = 80,
      max_height = 10,
      focusable = true,
      focus_id = ctx.method,
      close_events = { 'CursorMoved', 'BufHidden', 'InsertLeave' },
      silent = true,
    })

    if winnr then
      M.last_signature_win = winnr

      -- Enhancements
      vim.wo[winnr].conceallevel = 3
      vim.wo[winnr].concealcursor = 'nvc'
      vim.wo[winnr].wrap = true
      vim.wo[winnr].linebreak = true

      -- Get the buffer from the window
      local bufnr = vim.api.nvim_win_get_buf(winnr)

      -- Keymaps for when focused
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = bufnr, silent = true, desc = 'Close signature' })
      vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = bufnr, silent = true, desc = 'Close signature' })

      -- Auto-close when leaving insert mode
      vim.api.nvim_create_autocmd('InsertLeave', {
        once = true,
        callback = function()
          if vim.api.nvim_win_is_valid(winnr) then
            vim.api.nvim_win_close(winnr, true)
          end
        end,
      })
    end
  end)
end

M.setup_global_defaults = function()
  M.setup_highlights()
  vim.o.winborder = 'single'

  vim.lsp.config('*', {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    root_markers = { '.git' },
    exit_timeout = 1000,
  })

  -- Let Noice handle signature help styling
  -- vim.lsp.handlers['textDocument/signatureHelp'] = M.fancy_signature
end

M.on_attach = function(client, bufnr)
  if client:supports_method('textDocument/documentHighlight') then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client:supports_method('textDocument/documentColor') then
    vim.lsp.document_color.enable(true, { bufnr = bufnr })
  end

  if not pcall(require, 'blink.cmp') and client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  vim.notify('Inlay hints ' .. (not enabled and 'enabled' or 'disabled'))
end

return M
