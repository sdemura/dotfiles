require("catppuccin").setup({
	flavour = "auto",
	background = {
		light = "latte",
		dark = "macchiato",
	},
	integrations = {
		fidget = true,
		fzf = true,
		treesitter = true,
		notify = true,
		mini = {
			enabled = true,
			indentscope_color = "lavender",
		},
		navic = { enabled = true, custom_bg = "NONE" },
		native_lsp = {
			enabled = true,
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
	},
})

vim.cmd.colorscheme("catppuccin")
