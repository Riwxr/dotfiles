return {
  "tools-life/taskwiki",
  ft = { "vimwiki", "markdown" },
  dependencies = {
    "vimwiki/vimwiki",
    "majutsushi/tagbar",
  },
  init = function()
    -- stop taskwiki from resetting maplocalleader
    vim.g.taskwiki_no_mappings = 1
  end,
  config = function()
    vim.g.taskwiki_disable_concealcursor = "yes"
    vim.g.taskwiki_sort_orders = { "status", "project" }
  end,
}

