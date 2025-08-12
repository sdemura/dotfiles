-- Plugin Setup and Configuration
-- This file contains plugin configurations separated from plugin definitions
-- for better portability between plugin managers

local M = {}

-- Conform.nvim configuration
function M.setup_conform()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			go = { "goimports", "gofmt" },
			sh = { "shfmt" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
	})
end

-- Fidget.nvim configuration
function M.setup_fidget()
	require("fidget").setup({
		notification = { override_vim_notify = true, window = { winblend = 0 } },
	})
end

-- Catppuccin theme configuration
function M.setup_catppuccin()
	require("catppuccin").setup({
		integrations = {
			gitsigns = true,
			fidget = true,
			lsp_trouble = true,
			treesitter = true,
			notify = true,
			mini = {
				enabled = true,
				indentscope_color = "lavendar",
			},
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
end

-- Lualine configuration
function M.setup_lualine()
	require("lualine").setup({
		options = {
			theme = "catppuccin",
			icons_enabled = true,
			component_separators = "|",
			section_separators = "",
		},
	})
end

-- FZF-Lua configuration
function M.setup_fzf()
	require("fzf-lua").setup({
		files = {
			fd_opts = [[--color=never --type f --type l --exclude .git --exclude .venv --exclude .ruff_cache --exclude .mypy_cache --hidden --no-ignore --follow]],
		},
		winopts = { preview = { layout = "vertical" } },
		fzf_opts = { ["--info"] = "default" },
		grep = {
			rg_opts = [[--hidden --column -g '!.venv' -g "!.git" -g "!.ruff_cache" -g "!.mypy_cache" --line-number --no-heading --no-ignore-vcs --color=always --smart-case --max-columns=4096]],
		},
		keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
	})
end

-- Treesitter configuration
function M.setup_treesitter()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"dockerfile",
			"gitcommit",
			"go",
			"gomod",
			"gowork",
			"hcl",
			"ini",
			"json",
			"make",
			"markdown",
			"python",
			"terraform",
			"toml",
			"yaml",
		},
		auto_install = true,
		highlight = { enable = true, use_languagetree = true },
		indent = { enable = true, disable = { "python", "yaml" } },
		endwise = { enable = true },
	})
end

-- Hop.nvim configuration
function M.setup_hop()
	require("hop").setup({
		keys = "etovxqpdygfblzhckisuran",
	})
end

-- Mini.nvim configuration
function M.setup_mini()
	require("mini.indentscope").setup({
		symbol = "│",
		draw = { animation = require("mini.indentscope").gen_animation.none() },
	})
	require("mini.cursorword").setup({ delay = 50 })
	require("mini.ai").setup({})
	require("mini.trailspace").setup({})
	require("mini.basics").setup({
		options = { basic = false, extra_ui = false },
		mappings = { basic = true, move_with_alt = false },
		autocommands = { basic = true, relnum_in_visual_mode = true },
	})
	vim.keymap.del({ "n", "v", "i" }, "<C-s>")
end

-- Neo-tree configuration
function M.setup_neotree()
	require("window-picker").setup({})
	require("neo-tree").setup({
		popup_border_style = "rounded",
		close_if_last_window = true,
		filesystem = {
			follow_current_file = { enabled = true },
			window = { mappings = { ["s"] = "none", ["S"] = "none" } },
			filtered_items = { visible = true, hide_gitignored = false, hide_dotfiles = false },
		},
	})
end

-- Bufferline configuration
function M.setup_bufferline()
	require("bufferline").setup({
		options = {
			mode = "tabs",
			always_show_bufferline = false,
			highlights = require("catppuccin.groups.integrations.bufferline").get(),
			offsets = { { filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" } },
		},
	})
end

-- Scope.nvim configuration
function M.setup_scope()
	require("scope").setup()
end

-- Simple plugins that just need setup() called with empty table
function M.setup_outline()
	require("outline").setup({})
end

function M.setup_tree_pairs()
	require("tree-pairs").setup({})
end

function M.setup_gitsigns()
	require("gitsigns").setup({})
end

function M.setup_remember()
	require("remember").setup({})
end

function M.setup_autopairs()
	require("nvim-autopairs").setup({})
end

function M.setup_surround()
	require("nvim-surround").setup({})
end

function M.setup_barbecue()
	require("barbecue").setup({})
end

-- Setup all plugins
function M.setup()
	-- Plugins with complex configuration
	M.setup_conform()
	M.setup_fidget()
	M.setup_catppuccin()
	M.setup_lualine()
	M.setup_fzf()
	M.setup_treesitter()
	M.setup_hop()
	M.setup_mini()
	M.setup_neotree()
	M.setup_bufferline()
	M.setup_scope()

	-- Simple plugins that just need setup({})
	M.setup_outline()
	M.setup_tree_pairs()
	M.setup_gitsigns()
	M.setup_remember()
	M.setup_autopairs()
	M.setup_surround()
	M.setup_barbecue()
end

return M
