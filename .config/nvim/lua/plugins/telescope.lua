return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',

      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },

      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = true },
    },

    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local themes = require('telescope.themes')

      telescope.setup({
        extensions = {
          ['ui-select'] = {
            themes.get_dropdown(),
          },
        },
      })

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      vim.keymap.set('n', '<leader>sh', builtin.help_tags)
      vim.keymap.set('n', '<leader>sk', builtin.keymaps)
      vim.keymap.set('n', '<leader>sf', builtin.find_files)
      vim.keymap.set('n', '<leader>ss', builtin.builtin)
      vim.keymap.set('n', '<leader>sw', builtin.grep_string)
      vim.keymap.set('n', '<leader>sg', builtin.live_grep)
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics)
      vim.keymap.set('n', '<leader>sr', builtin.resume)
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles)
      vim.keymap.set('n', '<leader><leader>', builtin.buffers)

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end)

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end)

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end)
    end,
  },
}

