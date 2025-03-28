-- set leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"hedyhli/outline.nvim",
		-- lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		opts = {},
	},
	{ "towolf/vim-helm", ft = "helm" },
	{ "tpope/vim-fugitive" },
	{ "shumphrey/fugitive-gitlab.vim" },
	{ "tpope/vim-rhubarb" },
	{ "tpope/vim-eunuch" },
	{ "yorickpeterse/nvim-tree-pairs", opts = {} },

	-- lsp zero start
	{ "VonHeikemen/lsp-zero.nvim", branch = "v4.x" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-path" },

	{ "hrsh7th/cmp-buffer" }, -- Required
	{ "L3MON4D3/LuaSnip" },
	{ "nvimtools/none-ls.nvim" },
	{ "folke/neodev.nvim", opts = {} },
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				override_vim_notify = true,
				window = {
					winblend = 0,
				},
			},
		},
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			lsp_inlay_hints = {
				enable = false,
			},
		},
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
	{ "onsails/lspkind.nvim" },
	-- lsp zero end

	{ "lewis6991/gitsigns.nvim", opts = {}, priority = 1002 },
	{ "vladdoster/remember.nvim", opts = {} },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				colorful_winsep = {
					enabled = true,
					color = "text",
				},
				mini = {
					indentscope_color = "lavendar",
				},
				hop = true,
				window_picker = true,
				fidget = true,
				dropbar = {
					enabled = true,
					color_mode = false,
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		-- lazy = false,
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
		-- lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				files = {
					fd_opts = [[--color=never --type f --type l --exclude .git --hidden --no-ignore --follow]],
				},
				winopts = {
					preview = {
						layout = "vertical",
					},
				},
				fzf_opts = {
					["--info"] = "default",
				},
				grep = {
					rg_opts = [[--hidden --column -g "!.git" --line-number --no-heading --color=always --smart-case --max-columns=4096]],
				},
				keymap = {
					fzf = {
						["ctrl-q"] = "select-all+accept",
					},
				},
			})
		end,
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
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
			})
		end,
		build = ":TSUpdate",
	},
	{
		"RRethy/nvim-treesitter-endwise",
		config = function()
			require("nvim-treesitter.configs").setup({
				endwise = {
					enable = true,
				},
			})
		end,
	},
	{
		"smoka7/hop.nvim",
		version = "*",
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			-- require("mini.bracketed").setup({})
			require("mini.indentscope").setup({
				symbol = "│",
				draw = { animation = require("mini.indentscope").gen_animation.none() },
			})
			require("mini.cursorword").setup({
				delay = 50,
			})
			require("mini.ai").setup({})
			require("mini.trailspace").setup({})
			require("mini.basics").setup({
				options = {
					basic = false,
					extra_ui = false,
				},
				mappings = {
					basic = true,
					move_with_alt = false,
				},
				autocommands = {
					basic = true,
					relnum_in_visual_mode = true,
				},
			})
			-- keymaps I don't want
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
					follow_current_file = {
						enabled = true,
					},
					window = {
						mappings = {
							["s"] = "none",
							["S"] = "none",
						},
					},
					filtered_items = {
						visible = true,
						hide_gitignored = false,
						hide_dotfiles = false,
					},
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
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},
	-- {
	-- 	"Bekaboo/dropbar.nvim",
	-- },
	{ "nvzone/volt", lazy = true },
	{
		"nvzone/menu",
		lazy = true,
	},
}, {})

--- options
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "noselect,menuone"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"
vim.opt.linebreak = true
vim.opt.list = true
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

-- disable some builtin plugins we don't use
vim.g.editorconfig = false
vim.g.loaded_man = false
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
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

-- START LSP-ZERO v4
local cmp = require("cmp")
cmp.setup({
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	mapping = cmp.mapping.preset.insert({
		-- confirm completion
		["<C-y>"] = cmp.mapping.confirm({ select = true }),

		-- scroll up and down the documentation window
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		-- { name = "nvim_lsp_signature_help" },
		{ name = "path", options = { trailing_slash = true } },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 4 },
	},
	-- formatting = cmp_format,
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = require("lspkind").cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		}),
	},
})

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes"




-- Add borders to floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		-- keymaps for LSP only
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
		-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

		vim.keymap.set("n", "<leader>F", "<cmd>:LspZeroFormat<CR>", { buffer = true })
	end,
})

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.hadolint,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.stylua,
	},
})

local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
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
})
lspconfig.helm_ls.setup({
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
})
lspconfig.bashls.setup({})
lspconfig.yamlls.setup({})
lspconfig.ruff.setup({})
lspconfig.pyright.setup({})
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			format = { enable = false },
			workspace = { checkThirdParty = "Disable" },
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
-- END LSP-ZERO v4


-- disable virtualtext
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	update_in_insert = true,
	underline = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = "  ",
		},
	},
})

-- end lsp config

-- gbrowse to work with gitlab
vim.api.nvim_create_user_command("Browse", function(gopts)
	vim.fn.system({ "open", gopts.fargs[1] })
end, { nargs = 1 })

-- trail whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = ":lua MiniTrailspace.trim()" })

-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimport()
	end,
	group = format_sync_grp,
})

-- quickly move back to git root
vim.api.nvim_create_user_command("CdGitRoot", function()
	local git_root = vim.fn.system("git rev-parse --show-toplevel")
	git_root = git_root:match("^%s*(.-)%s*$")
	vim.api.nvim_set_current_dir(git_root)
	vim.notify("changed dir to " .. git_root)
end, {})

-- theme
vim.cmd.colorscheme("catppuccin-macchiato")
-- bufferline for tabs only
require("bufferline").setup({
	options = {
		mode = "tabs",
		always_show_bufferline = false,
		highlights = require("catppuccin.groups.integrations.bufferline").get(),
		offsets = {
			{
				filetype = "neo-tree",
				text = "Neo-tree",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
})

-- keymaps: see `:help vim.keymap.set()`
local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)
vim.keymap.set("n", "<leader>lu", "<cmd>:Lazy update<CR>", opts)
vim.keymap.set("n", "q", "<Nop>", opts) -- disable macros
vim.keymap.set({ "n", "v", "i" }, "<F1>", "<Nop>", opts) -- disable f1 help]
vim.keymap.set("n", "<leader>r", "<cmd>:CdGitRoot<CR>", opts)
vim.keymap.set(
	"n",
	"<leader>yf",
	':let @+ = expand("%:p")<cr>:lua print("Copied path to: " .. vim.fn.expand("%:p"))<cr>',
	opts
)

-- fzf keybinds
vim.keymap.set("n", "<leader><leader>", "<cmd>:FzfLua<cr>", opts)
vim.keymap.set("n", "<leader>f", "<cmd>:FzfLua files<CR>", opts)
vim.keymap.set("n", "<leader>g", "<cmd>:FzfLua live_grep_glob<CR>", opts)
vim.keymap.set("n", "<leader>G", "<cmd>:FzfLua grep_curbuf<CR>", opts)
vim.keymap.set("n", "<leader>s", "<cmd>:FzfLua lsp_document_symbols<CR>", opts)
vim.keymap.set("n", "<leader>d", "<cmd>:FzfLua lsp_workspace_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>cc", "<cmd>:FzfLua files cwd=~/.config<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>:FzfLua buffers<cr>", opts)
vim.keymap.set("n", '<leader>"', "<cmd>:FzfLua registers<cr>", opts)
vim.keymap.set("n", "<leader>'", "<cmd>:FzfLua marks<cr>", opts)
vim.keymap.set("i", "<C-r>", "<cmd>:FzfLua registers<cr>", opts)

-- outline
vim.keymap.set("n", "<leader>o", "<cmd>:Outline<CR>", opts)

-- hop
vim.keymap.set("n", "s", "<cmd>:HopWord<CR>", opts)

-- neotree
vim.keymap.set("n", "-", "<cmd>:Neotree toggle<CR>", opts)
vim.keymap.set("n", "_", "<cmd>:Neotree toggle reveal<CR>", opts)

-- quickfix stuff
vim.keymap.set("n", "<leader>cn", "<cmd>:cnext<CR>")
vim.keymap.set("n", "<leader>cp", "<cmd>:cprev<CR>")

-- git browse
vim.keymap.set("n", "<leader>B", "<cmd>:GBrowse<CR>")

-- mouse mode!
-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
	require("menu.utils").delete_old_menus()

	vim.cmd.exec('"normal! \\<RightMouse>"')

	local menu_options = {

		{
			name = "Format Buffer",
			cmd = function()
				vim.lsp.buf.format()
			end,
			rtxt = "<leader>fm",
		},
		{
			name = "Code Actions",
			cmd = vim.lsp.buf.code_action,
			rtxt = "<leader>ca",
		},
		{ name = "separator" },
		{
			name = "Goto Definition",
			cmd = vim.lsp.buf.definition,
			rtxt = "gd",
		},
		{
			name = "Goto Declaration",
			cmd = vim.lsp.buf.declaration,
			rtxt = "gD",
		},
		{
			name = "Goto Implementation",
			cmd = vim.lsp.buf.implementation,
			rtxt = "gi",
		},
		{ name = "separator" },
		{
			name = "Show signature help",
			cmd = vim.lsp.buf.signature_help,
			rtxt = "gs",
		},
		{
			name = "Find References",
			cmd = vim.lsp.buf.references,
			rtxt = "gr",
		},
	}

	require("menu").open(menu_options, { mouse = true })
end, {})
