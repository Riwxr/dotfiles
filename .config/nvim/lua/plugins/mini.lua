-- Collection of various small independent plugins/modules
return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()
		require("mini.snippets").setup()
		require("mini.comment").setup()
		require("mini.pairs").setup()
		require("mini.files").setup()
		require("mini.cursorword").setup()
		require("mini.splitjoin").setup()
		require("mini.sessions").setup()

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = true })

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end

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
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- Highlight standalone 'Thoughts', 'Wanna', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()Thoughts()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()Wanna()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}
