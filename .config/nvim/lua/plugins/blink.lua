--Auto completion
return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		"folke/lazydev.nvim",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",

			-- manual trigger
			["<Leader><Tab>"] = { "show" },

			-- Accept completion or fallback to Enter
			["<CR>"] = { "accept", "fallback" },

			-- Next item
			["<Tab>"] = { "select_next", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			-- Previous item
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },

			-- Snippets
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },

			-- Signature help
			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			menu = {
				winblend = 1,
			},
			list = {
				selection = {
					preselect = true,
				},
			},
			documentation = {
				auto_show = false,
				auto_show_delay_ms = 500,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	},
}
