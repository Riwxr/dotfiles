return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	dependencies = { "nvim-mini/mini.icons" },
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {},
	---@diagnostic enable: missing-fields
	keys = {
		{
			"<leader>fF",
			function()
				require("fzf-lua").files()
			end,
			desc = "[F]ind [F]iles - CWD",
		},
		{
			"<leader>fh",
			function()
				require("fzf-lua").files({ cwd = vim.fn.expand("~/.config/hypr") })
			end,
			desc = "[F]ind [H]yprland Config",
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "[F]ind by [G]rep in CWD",
		},
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[F]ind [C]onfig Files - Nvim",
		},
		{
			"<leader>ff",
			function()
				require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = " [F]ind [F]iles in Files Dir",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").builtin()
			end,
			desc = "[F]ind [B]uiltins",
		},
		{
			"<leader>fk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "[F]ind [K]eymaps",
		},
		{
			"<leader>fw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "[F]ind current [W]ord",
		},
		{
			"<leader>fW",
			function()
				require("fzf-lua").grep_CWORD()
			end,
			desc = "[F]ind current [W]ORD",
		},
		{
			"<leader>fd",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "[F]ind [D]iagnostics",
		},
		{
			"<leader>fs",
			function()
				require("fzf-lua").resume()
			end,
			desc = "[F]ind re[S]ume",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = " [F]ind [R]ecent Files",
		},
		{
			"<leader><leader>",
			function()
				require("fzf-lua").buffers()
			end,
			desc = " [F]ind [B]uffer",
		},
		{
			"<leader>fs",
			function()
				require("fzf-lua").spellcheck()
			end,
			desc = " [F]ind [S]pellcheck",
		},
	},
}
