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
	-- start plugins
	"tpope/vim-fugitive",
	"shumphrey/fugitive-gitlab.vim",
	"tpope/vim-rhubarb",
	"tpope/vim-eunuch",
	{ "yorickpeterse/nvim-tree-pairs", opts = {} },

	-- lsp zero start
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-path" },

	-- { "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "hrsh7th/cmp-buffer" }, -- Required
	{ "L3MON4D3/LuaSnip" },
	{ "nvimtools/none-ls.nvim" },
	{ "jayp0521/mason-null-ls.nvim" },
	{ "folke/neodev.nvim", opts = {} },
	{
		"j-hui/fidget.nvim",
		-- event = "LspAttach",
		opts = {
			notification = {
				override_vim_notify = true,
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
	-- { "norcalli/nvim-colorizer.lua" },
	{ "EdenEast/nightfox.nvim", priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "projekt0n/github-nvim-theme", priority = 1000 },
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		opts = {
			options = {
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
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
		keys = {
			{ "<leader><leader>", "<cmd>:FzfLua<cr>" },
			{ "<leader>f", "<cmd>:FzfLua files<CR>" },
			{ "<leader>g", "<cmd>:FzfLua live_grep<CR>" },
			{ "<leader>G", "<cmd>:FzfLua git_status<CR>" },
			{ "<leader>s", "<cmd>:FzfLua lsp_document_symbols<CR>" },
			{ "<leader>d", "<cmd>:FzfLua lsp_workspace_diagnostics<CR>" },
			{ "<leader>cc", "<cmd>:FzfLua files cwd=~/.config<CR>" },
			{ "<leader>b", "<cmd>:FzfLua buffers<cr>" },
			{ '<leader>"', "<cmd>:FzfLua registers<cr>" },
			{ "<leader>'", "<cmd>:FzfLua marks<cr>" },
			{ "<C-r>", "<cmd>:FzfLua registers<cr>", mode = "i" },
		},
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
		keys = {
			{ "s", "<cmd>:HopWord<CR>" },
		},
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.bracketed").setup({})
			require("mini.indentscope").setup({
				symbol = "│",
				draw = { animation = require("mini.indentscope").gen_animation.none() },
			})
			require("mini.cursorword").setup({
				delay = 50,
			})
			require("mini.ai").setup({})
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
		keys = {
			{ "-", "<cmd>:Neotree  toggle<CR>" },
			{ "_", "<cmd>:Neotree  toggle reveal<CR>" },
		},
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {},
	},
	{ "windwp/nvim-autopairs", opts = {} },
	{ "kylechui/nvim-surround", opts = {} },
	-- {
	-- 	"akinsho/bufferline.nvim",
	-- 	version = "*",
	-- 	dependencies = "nvim-tree/nvim-web-devicons",
	-- },
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup()
		end,
		keys = {
			{ "<leader>a", "<cmd>:AerialToggle!<CR>" },
		},
	},
	-- 	-- Uncomment next line if you want to follow only stable versions
	-- 	-- version = "*"
	-- },
	-- End plugins
	--    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
	-- { import = 'custom.plugins' },
}, {})

-- theme
vim.cmd.colorscheme("terafox")
-- require("bufferline").setup({ options = { mode = "tabs", always_show_bufferline = false } })
-- require("bufferline").setup({
-- 	options = {
-- 		offsets = {
-- 			{
-- 				filetype = "neo-tree",
-- 				text = "Neo-tree",
-- 				highlight = "Directory",
-- 				text_align = "left",
-- 			},
-- 		},
-- 	},
-- })

-- make it look nice with terafox
vim.cmd("hi MiniJump2dSpot guifg=#eaeeee gui=bold,italic,underline")

--- options
vim.o.breakindent = true
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

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>lu", "<cmd>:Lazy update<cr>", opts)

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- disable macros
vim.keymap.set("n", "q", "<Nop>")
-- vim.keymap.del({ "n", "v", "i" }, "q")

-- trail whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

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

vim.keymap.set("n", "<leader>r", "<cmd>:CdGitRoot<CR>", {})

-- start lsp config
require("mason-null-ls").setup()
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

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
})

local lsp_zero = require("lsp-zero")
local cmp = require("cmp")

-- doesn't work, but sometimes it does even when not set...
-- lsp_zero.set_sign_icons({
-- 	error = "✘",
-- 	warn = "▲",
-- 	hint = "⚑",
-- 	info = "»",
-- })

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

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {},
	handlers = {
		lsp_zero.default_setup,
		["lua_ls"] = function()
			local lspconfig = require("lspconfig")
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
		end,
		["gopls"] = function()
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
		end,
	},
})

lsp_zero.on_attach(function(_, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })

	vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = true })
	vim.keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = true })
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format({ async = true, timeout_ms = 10000 })
	end, { desc = "Format current buffer with LSP" })

	vim.api.nvim_buf_create_user_command(bufnr, "ToggleInlayHints", function(_)
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })
	end, { desc = "Toggle Inlay Hints" })

	vim.keymap.set("n", "<leader>F", "<cmd>:Format<CR>", { buffer = true })
	vim.keymap.set("n", "<leader>li", "<cmd>:ToggleInlayHints<CR>", { buffer = true })

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		update_in_insert = true,
		underline = false,
	})
end)

-- set sign icons
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
