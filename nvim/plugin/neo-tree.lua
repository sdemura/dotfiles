local palette = require("catppuccin.palettes").get_palette()

require("window-picker").setup({
	highlights = {
		statusline = { focused = { bg = palette.mauve }, unfocused = { bg = palette.overlay1 } },
		winbar = { focused = { bg = palette.mauve }, unfocused = { bg = palette.overlay1 } },
	},
})

require("neo-tree").setup({
	popup_border_style = "rounded",
	close_if_last_window = true,
	filesystem = {
		follow_current_file = { enabled = true },
		window = { mappings = { ["s"] = "none", ["S"] = "none" } },
		filtered_items = {
			visible = true,
			hide_gitignored = false,
			hide_dotfiles = false,
			never_show = { ".git" },
		},
	},
})

vim.keymap.set("n", "-", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree file explorer" })
vim.keymap.set("n", "_", "<cmd>Neotree toggle reveal<CR>", { desc = "Toggle Neo-tree and reveal current file" })
