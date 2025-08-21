-- Pure plugin definitions with no configuration
-- All plugin setup is handled in plugin-setup.lua and called from init.lua

return {
	-- Simple plugins with no configuration
	{ "towolf/vim-helm", ft = "helm" },
	{ "tpope/vim-fugitive" },
	{ "shumphrey/fugitive-gitlab.vim" },
	{ "tpope/vim-rhubarb" },
	{ "tpope/vim-eunuch" },
	{ "b0o/schemastore.nvim" },

	-- Simple plugins (configuration handled in plugin-setup.lua)
	{ "hedyhli/outline.nvim", cmd = { "Outline", "OutlineOpen" } },
	{ "yorickpeterse/nvim-tree-pairs" },
	{ "lewis6991/gitsigns.nvim" },
	{ "vladdoster/remember.nvim" },
	{ "windwp/nvim-autopairs" },
	{ "kylechui/nvim-surround" },
	{
		"BrunoKrugel/bbq.nvim",
		name = "barbecue",
		version = "*",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
	},

	-- LSP and Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "onsails/lspkind.nvim" },

	-- Plugins with configuration handled externally
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		module = "conform",
		cmd = { "ConformInfo" },
	},
	{ "j-hui/fidget.nvim" },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "nvim-lualine/lualine.nvim" },
	{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "RRethy/nvim-treesitter-endwise" },
		build = ":TSUpdate",
	},
	{ "smoka7/hop.nvim", version = "*" },
	{ "echasnovski/mini.nvim" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
	},
	{
		"akinsho/bufferline.nvim",
		after = "catppuccin",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{ "tiagovla/scope.nvim" },
}
