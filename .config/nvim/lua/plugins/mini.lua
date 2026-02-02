-- Collection of various small independent plugins/modules
return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = true })

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end

		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}
