return {
  'ravitemer/mcphub.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
  opts = {
    extensions = {
      avante = {
        make_slash_commands = true,
      },
      copilotchat = {
        enabled = true,
        convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
        convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
        add_mcp_prefix = false, -- Add "mcp_" prefix to function names
      },
    },
  },
  config = function()
    require('mcphub').setup()
  end,
}
