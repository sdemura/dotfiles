-- Set global and local -- Set global and local leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Specifications
require("lazy").setup({
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		opts = {},
	},
	{ "towolf/vim-helm", ft = "helm" },
	{ "tpope/vim-fugitive" },
	{ "shumphrey/fugitive-gitlab.vim" },
	{ "tpope/vim-rhubarb" },
	{ "tpope/vim-eunuch" },
	{ "yorickpeterse/nvim-tree-pairs", opts = {} },

	-- LSP, Completion, and Formatter Plugins
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "onsails/lspkind.nvim" },

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		module = "conform",
		cmd = { "ConformInfo" },
		opts = {
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
			-- format_on_save = {
			-- 	timeout_ms = 500,
			-- 	lsp_fallback = true,
			-- },
		},
	},

	{ "folke/neodev.nvim", opts = {} },
	{
		"j-hui/fidget.nvim",
		opts = { notification = { override_vim_notify = true, window = { winblend = 0 } } },
	},
	-- {
	-- 	"ray-x/go.nvim",
	-- 	dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
	-- 	opts = { lsp_inlay_hints = { enable = false } },
	-- 	ft = { "go", "gomod" },
	-- 	build = ':lua require("go.install").update_all_sync()',
	-- },

	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "vladdoster/remember.nvim", opts = {} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
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
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "catppuccin",
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				files = { fd_opts = [[--color=never --type f --type l --exclude .git --exclude .venv --exclude .ruff_cache --hidden --no-ignore --follow]] },
				winopts = { preview = { layout = "vertical" } },
				fzf_opts = { ["--info"] = "default" },
				grep = {
					rg_opts = [[--hidden --column -g '!.venv' -g "!.git" --line-number --no-heading --no-ignore-vcs --color=always --smart-case --max-columns=4096]],
				},
				keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "RRethy/nvim-treesitter-endwise" },
		build = ":TSUpdate",
		config = function()
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
		end,
	},
	{
		"smoka7/hop.nvim",
		version = "*",
		opts = { keys = "etovxqpdygfblzhckisuran" },
	},
	{
		"echasnovski/mini.nvim",
		config = function()
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
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
		config = function()
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
		end,
	},
	{ "windwp/nvim-autopairs", opts = {} },
	{ "kylechui/nvim-surround", opts = {} },
	{
		"akinsho/bufferline.nvim",
		after = "catppuccin",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	},
	{
		"BrunoKrugel/bbq.nvim",
		name = "barbecue",
		version = "*",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{ "b0o/schemastore.nvim" },
}, {})

--- Options ---
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = "useopen"
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }
vim.opt.wrap = false

-- Disable specific built-in plugins
vim.g.editorconfig = false
vim.g.loaded_man = false
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- LSP & COMPLETION SETUP
local cmp = require("cmp")
local lspconfig = require("lspconfig")
local lspkind = require("lspkind")

-- nvim-cmp setup
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol",
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
})

-- Add rounded borders to LSP floating windows.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Callback function executed when an LSP client attaches to a buffer.
local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", { desc = "Show hover information" }, opts))
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", { desc = "Go to definition" }, opts))
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", { desc = "Go to declaration" }, opts))
	vim.keymap.set(
		"n",
		"gi",
		vim.lsp.buf.implementation,
		vim.tbl_extend("force", { desc = "Go to implementation" }, opts)
	)
	vim.keymap.set(
		"n",
		"go",
		vim.lsp.buf.type_definition,
		vim.tbl_extend("force", { desc = "Go to type definition" }, opts)
	)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", { desc = "List references" }, opts))
	vim.keymap.set(
		"n",
		"gs",
		vim.lsp.buf.signature_help,
		vim.tbl_extend("force", { desc = "Show signature help" }, opts)
	)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, vim.tbl_extend("force", { desc = "Rename symbol" }, opts))
	vim.keymap.set(
		"n",
		"<leader>ca",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", { desc = "Trigger code action" }, opts)
	)
	vim.keymap.set(
		"n",
		"<leader>e",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", { desc = "Open floating diagnostic window" }, opts)
	)

	vim.keymap.set("n", "gK", function()
		local current_config = vim.diagnostic.config().virtual_lines
		vim.diagnostic.config({ virtual_lines = not current_config })
	end, vim.tbl_extend("force", { desc = "Toggle diagnostic virtual text" }, opts))

	vim.keymap.set("n", "gH", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, vim.tbl_extend("force", { desc = "Toggle inlay hints" }, opts))

	vim.diagnostic.config({
		virtual_text = false,
		virtual_lines = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚",
				[vim.diagnostic.severity.WARN] = "󰀪",
				[vim.diagnostic.severity.HINT] = "󰌶",
				[vim.diagnostic.severity.INFO] = " ",
			},
		},
	})
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define server-specific LSP configurations.
local servers = {
	gopls = {
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},
	helm_ls = {
		settings = {
			["helm-ls"] = {
				yamlls = {
					path = "yaml-language-server",
					config = {
						schemas = {
							["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.29.12-standalone-strict/_definitions.json"] = "**/templates/**",
						},
					},
				},
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				format = { enable = false },
				workspace = { checkThirdParty = "Disable" },
				telemetry = { enable = false },
				diagnostics = { globals = { "vim" } },
			},
		},
	},
	bashls = {},
	yamlls = {
		settings = {
			yaml = {
				schemaStore = {
					-- You must disable built-in schemaStore support if you want to use
					-- this plugin and its advanced options like `ignore`.
					enable = false,
					-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	},
	ruff = {},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	pyright = {},
}

for server_name, custom_opts in pairs(servers) do
	lspconfig[server_name].setup(vim.tbl_deep_extend("force", {
		on_attach = on_attach,
		capabilities = capabilities,
	}, custom_opts or {}))
end

-- autoformat go
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd(
	"BufWritePre",
	{ command = ":lua MiniTrailspace.trim()", desc = "Trim trailing whitespace" }
)

vim.api.nvim_create_user_command("GitRoot", function()
	local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
	local git_root = ""
	if handle then -- Check if handle is not nil
		git_root = handle:read("*a"):match("^%s*(.-)%s*$")
		handle:close()
	end

	if git_root and git_root ~= "" then
		vim.api.nvim_set_current_dir(git_root)
		vim.notify("Changed directory to " .. git_root, vim.log.levels.INFO)
	else
		vim.notify("Not in a Git repository.", vim.log.levels.WARN)
	end
end, { desc = "Change current directory to Git repository root" })

-- Final Setup (Theme, UI, Keymaps)
vim.cmd.colorscheme("catppuccin-macchiato")

require("bufferline").setup({
	options = {
		mode = "tabs",
		always_show_bufferline = false,
		highlights = require("catppuccin.groups.integrations.bufferline").get(),
		offsets = { { filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" } },
	},
})

local key_opts = { noremap = true, silent = true }

-- Keymaps:
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Leader key" })
vim.keymap.set("n", "<Esc><Esc>", "<cmd>:nohlsearch<CR><C-l><CR>", key_opts) -- Clear search highlighting and redraw screen
vim.keymap.set("n", "<leader>lu", "<cmd>:Lazy update<CR>", { desc = "Update Lazy plugins" })
vim.keymap.set("n", "q", "<Nop>", key_opts) -- Disable the 'q' key
vim.keymap.set({ "n", "v", "i" }, "<F1>", "<Nop>", key_opts) -- Disable the <F1> key (help)
vim.keymap.set("n", "<leader>r", "<cmd>:CdGitRoot<CR>", { desc = "Change directory to Git root" })

vim.keymap.set("n", "<leader>yf", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied path to clipboard:\n" .. path, vim.log.levels.INFO, { title = "Yank File Path" })
end, { noremap = true, silent = true, desc = "Yank full file path to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>F", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 1000,
	})
end, { desc = "Format buffer (manual)" })

vim.keymap.set({ "n", "v" }, "<F3>", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 1000,
	})
end, { desc = "Format buffer (manual)" })

-- fzf-lua keybinds:
vim.keymap.set("n", "<leader><leader>", "<cmd>:FzfLua<cr>", { desc = "Open FzfLua default fuzzy finder" })
vim.keymap.set("n", "<leader>f", "<cmd>:FzfLua files<CR>", { desc = "Find files using FzfLua" })
vim.keymap.set("n", "<leader>g", "<cmd>:FzfLua live_grep_glob<CR>", { desc = "Live grep across files" })
vim.keymap.set("n", "<leader>G", "<cmd>:FzfLua grep_curbuf<CR>", { desc = "Grep in current buffer" })
vim.keymap.set("n", "<leader>s", "<cmd>:FzfLua lsp_document_symbols<CR>", { desc = "List LSP document symbols" })
vim.keymap.set(
	"n",
	"<leader>d",
	"<cmd>:FzfLua lsp_workspace_diagnostics<CR>",
	{ desc = "List LSP workspace diagnostics" }
)
vim.keymap.set("n", "<leader>cc", "<cmd>:FzfLua files cwd=~/.config<CR>", { desc = "Find files in ~/.config" })
vim.keymap.set("n", "<leader>b", "<cmd>:FzfLua buffers<cr>", { desc = "List open buffers" })
vim.keymap.set("n", '<leader>"', "<cmd>:FzfLua registers<cr>", { desc = "Show registers" })
vim.keymap.set("n", "<leader>'", "<cmd>:FzfLua marks<cr>", { desc = "Show marks" })
vim.keymap.set("i", "<C-r>", "<cmd>:FzfLua registers<cr>", { desc = "Show registers (insert mode)" })

-- outline.nvim keybinds:
vim.keymap.set("n", "<leader>o", "<cmd>:Outline<CR>", { desc = "Open Outline window" })

-- hop.nvim keybinds:
vim.keymap.set("n", "s", "<cmd>:HopWord<CR>", { desc = "Jump to a word using Hop" })

-- neo-tree.nvim keybinds:
vim.keymap.set("n", "-", "<cmd>:Neotree toggle<CR>", { desc = "Toggle Neo-tree file explorer" })
vim.keymap.set("n", "_", "<cmd>:Neotree toggle reveal<CR>", { desc = "Toggle Neo-tree and reveal current file" })

-- Quickfix list keybinds:
vim.keymap.set("n", "<leader>cn", "<cmd>:cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<leader>cp", "<cmd>:cprev<CR>", { desc = "Previous quickfix item" })

-- Git browse keybind:
vim.keymap.set("n", "<leader>B", "<cmd>:GBrowse<CR>", { desc = "Open current file in browser" })
