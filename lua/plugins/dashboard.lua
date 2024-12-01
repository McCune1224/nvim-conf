return {
  'nvimdev/dashboard-nvim',
  lazy = false,
  event = 'VimEnter',
  opts = function()
    local logo = [[

                      .,-:;//;:=,,                               
                  . :H@@@MM@M#H/.,+%;,,                          
               ,/X+ +M@@M@MM%=,-%HMMM@X/,,                       
             -+@MM; $M@@MH+-,;XMMMM@MMMM@+-,                     
            ;@M@@M- XM@X;. -+XXXXXHHH@M@M#@/.,                   
          ,%MM@@MH ,@%=             .---=-=:=,.,                 
          =@#@@@MX.,                -%HX$$%%%:;,                 
         =-./@M@M$                   .;@MMMM@MM:,                
         X@/ -$MM/                    . +MM@@@M$,                
        ,@M@H: :@:                    . =X#@@@@-,                
        ,@@@MMX, .                    /H- ;@M@M=,                
        .H@@@@M@+,                    %MM+..%#$.,                
         /MMMM@MMH/.                  XM@MH; =;,                 
          /%+%$XHH@$=              , .H@@@@MX,,                  
           .=--------.           -%H.,@@@@@MX,,                  
           .%MM@@@HHHXX$$$%+- .:$MMX =M@@MM%.,                   
             =XMMM@MM@MM#H;,-+HMM@M+ /MMMX=,                     
               =%@M@M#@$-.=$@MM@@@M; %M%=,                       
                 ,:+$+-,/H#MMMMMMM@= =,,                         
                       =++%%%%+/:-.,                             
  ]]

    logo = string.rep('\n', 8) .. logo .. '\n\n'

    local builtin = require 'telescope.builtin'
    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, '\n'),
      -- stylua: ignore
      center = {
        { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
        { action = "ene | startinsert",                                        desc = " New file",        icon = " ", key = "n" },
        { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
        { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
        { action = function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end
,   desc = " Config",          icon = " ", key = "c" },
        -- { action = 'Oil ~/.config/nvim',   desc = " Config",          icon = " ", key = "c" },
          -- { action = 'lua require("lazyvim.util").telescope.config_files()()',   desc = " Config",          icon = " ", key = "c" },
        { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "R" },
        { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
        { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
      },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
      button.key_format = '  %s'
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DashboardLoaded',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    return opts
  end,
}
