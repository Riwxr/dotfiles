return {
  "preservim/vim-markdown",
  ft = { "markdown" },
  init = function()
    -- optional but recommended
    vim.g.vim_markdown_folding_disabled = 1
    vim.g.vim_markdown_conceal = 0
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_strikethrough = 1
  end,
}

