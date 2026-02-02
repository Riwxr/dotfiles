--Useful plugin to show you pending keybinds; Help Popup
return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		delay = 0, --One sec delay before help (in ms btw)

		-- Document existing key chains
		spec = {
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
		},
	},
}
