return {
	require("lspconfig").harper_ls.setup({
		settings = {
			["harper-ls"] = {
				linters = {
					SentenceCapitalization = false,
					SpellCheck = false,
				},
			},
		},
	}),
}
