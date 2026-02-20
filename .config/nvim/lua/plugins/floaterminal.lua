return {
  "nvzone/floaterm",
  dependencies = "nvzone/volt",
  cmd = "FloatermToggle",
  opts = {
    border = true,

    mappings = {
      sidebar = function(buf)
        -- remap edit from `e` to `r`
        vim.keymap.set("n", "r", function()
          require("floaterm.api").rename_term()
        end, { buffer = buf })

        -- optionally disable `e`
        vim.keymap.set("n", "e", "<nop>", { buffer = buf })
      end,
    },
  },
}
