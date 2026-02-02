local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local events = require("luasnip.util.events")

local snippet = s("sh", {
	t({ "#!/usr/bin/env bash", "", "" }),
}, {
	callbacks = {
		[-1] = {
			[events.leave] = function()
				vim.cmd("write")
				local file = vim.fn.expand("%:p")
				if file ~= "" then
					vim.fn.system({ "chmod", "+x", file })
				end
			end,
		},
	},
})

ls.add_snippets("sh", { snippet })
ls.add_snippets("bash", { snippet })
