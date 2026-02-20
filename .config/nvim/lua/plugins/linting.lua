return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linter_by_ft = {
			python = { "pylint" },
		}

		local lint_auggroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "Insertleave" }, {
			group = lint_auggroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
