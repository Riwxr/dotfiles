return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.config").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
			ensure_installed = { "python", "html", "lua", "markdown" },
			auto_install = true,
		})
	end,
}
