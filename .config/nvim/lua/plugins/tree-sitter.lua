return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function ()
    local config = require('nvim-treesitter.config')

    config.setup ({
      install_dir = vim.fn.stdpath('data') .. '/site',
      ensure_installed = {
          'python', 'html', 'lua', 'markdown', 'bash' 
      },
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
  })
  end
}

