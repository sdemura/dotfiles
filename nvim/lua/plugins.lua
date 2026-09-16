vim.pack.add({
	-- Simple plugins
	"https://github.com/towolf/vim-helm",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/shumphrey/fugitive-gitlab.vim",
	"https://github.com/tpope/vim-rhubarb",
	"https://github.com/tpope/vim-eunuch",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/hedyhli/outline.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-mini/mini.nvim",

	-- Plugins with version pinning
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3.x") },
	"https://github.com/SmiteshP/nvim-navic",

	-- Dependencies (listed explicitly, no nesting)
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/s1n7ax/nvim-window-picker",

	-- Completion
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },

	-- Treesitter
	"https://github.com/arborist-ts/arborist.nvim",

	-- Formatting and UI
	"https://github.com/stevearc/conform.nvim",
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})
