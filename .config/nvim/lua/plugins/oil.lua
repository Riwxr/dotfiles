return {
	"stevearc/oil.nvim",
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
	opts = {
		float = {
			padding = 2,
			max_width = 100,
			max_height = 40,
			border = "rounded",
		},
		view_options = {
			show_hidden = true,
		},
	},
}
