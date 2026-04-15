require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<Tab>"] = { "select_and_accept", "fallback" },
		["<C-u>"] = { "scroll_documentation_up", "fallback" },
		["<C-d>"] = { "scroll_documentation_down", "fallback" },
	},
	completion = {
		documentation = { auto_show = true },
		list = {
			selection = { auto_insert = false },
		},
	},
	sources = {
		default = { "lsp", "path", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust" },
})

