local function OpenRouterProviderGenerator(modelname)
  return {
    __inherited_from = 'openai',
    endpoint = 'https://openrouter.ai/api/v1',
    api_key_name = 'OPENROUTER_API_KEY',
    model = modelname, -- Default model
    timeout = 30000,
    extra_request_body = {
      temperature = 0.5,
      --   -- max_tokens = 4096,
    },
  }
end

return {
  'yetone/avante.nvim',
  -- build = vim.fn.has 'win32' and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  build = 'make',
  event = 'VeryLazy',
  dependencies = {
    'folke/snacks.nvim', -- for input provider snacks
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, for icons
    'stevearc/dressing.nvim', -- optional, for better UI
    -- Add other optional dependencies as needed
  },
  ---@module 'avante'
  ---@type avante.ConfigA
  opts = {
    provider = 'copilot',
    -- provider = 'openrouter',
    providers = {
      openrouter_deepseek = OpenRouterProviderGenerator 'deepseek/deepseek-r1-0528',
      openrouter_kiwi = OpenRouterProviderGenerator 'moonshotai/kimi-k2',
      openrouter_qwen3 = OpenRouterProviderGenerator 'qwen/qwen3-coder',
      -- perplexity = {
      --   -- Inherit OpenAI-compatible structure
      --   __inherited_from = 'openai',
      --   -- API key environment variable
      --   api_key_name = 'PERPLEXITY_API_KEY',
      --   -- Perplexity API endpoint
      --   endpoint = 'https://api.perplexity.ai',
      --   -- Choose your preferred model
      --   model = 'llama-3.1-sonar-large-128k-online',
      --   -- Timeout configuration
      --   timeout = 30000,
      --   -- Additional request parameters
      --   extra_request_body = {
      --     temperature = 0.7,
      --     -- max_tokens = 4096,
      --   },
      -- },
    },
    spinner = {
      editing = {
        '⡀',
        '⠄',
        '⠂',
        '⠁',
        '⠈',
        '⠐',
        '⠠',
        '⢀',
        '⣀',
        '⢄',
        '⢂',
        '⢁',
        '⢈',
        '⢐',
        '⢠',
        '⣠',
        '⢤',
        '⢢',
        '⢡',
        '⢨',
        '⢰',
        '⣰',
        '⢴',
        '⢲',
        '⢱',
        '⢸',
        '⣸',
        '⢼',
        '⢺',
        '⢹',
        '⣹',
        '⢽',
        '⢻',
        '⣻',
        '⢿',
        '⣿',
      },
      generating = { '·', '✢', '✳', '∗', '✻', '✽' }, -- Spinner characters for the 'generating' state
      thinking = { '', '' }, -- Spinner characters for the 'thinking' state
    },
  },
}
