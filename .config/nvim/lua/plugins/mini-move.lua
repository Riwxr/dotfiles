return {
  {
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup({
        -- Move lines in Normal mode
        mappings = {
          left = "<A-h>",
          right = "<A-l>",
          down = "<A-j>",
          up = "<A-k>",

          -- Move selections in Visual mode
          line_left = "<A-h>",
          line_right = "<A-l>",
          line_down = "<A-j>",
          line_up = "<A-k>",
        },
      })
    end,
  },
}

