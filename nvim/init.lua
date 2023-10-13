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

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

require("lazy").setup({
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },
	-- lazy.nvim
	{
		"vladdoster/remember.nvim",
		config = function()
			require("remember")
		end,
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
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		-- after gruvbox
		priority = 1001,
		config = function()
			require("bufferline").setup({
				-- highlights = require("catppuccin.groups.integrations.bufferline").get(),
				options = {
					mode = "tabs",
					always_show_bufferline = false,
					show_buffer_icons = false,
					enforce_regular_tabs = true,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							-- highlight = "directory",
							text_align = "left",
							separator = true,
						},
					},
				},
			})
		end,
	},
	{ "tpope/vim-fugitive" },
	{ "shumphrey/fugitive-gitlab.vim" },
	-- { "tpope/vim-unimpaired" },
	{ "tpope/vim-eunuch" },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
		keys = {
			{ "<leader>T", "<cmd>:TroubleToggle todo<cr>" },
		},
	},
	{
		"smoka7/hop.nvim",
		config = function()
			require("hop").setup()
		end,
		keys = { { "s", "<cmd>:HopWord<CR>" }, { "S", "<cmd>:HopAnywhere<CR>" } },
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	main = "ibl",
	-- 	opts = {},
	-- 	config = function()
	-- 		require("ibl").setup({
	-- 			show_current_context = true,
	-- 			colored_indent_levels = true,
	-- 		})
	-- 	end,
	-- },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- after gruvbox
		priority = 1002,
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox",
					globalstatus = false,
					section_separators = "",
					component_separators = "",
					disabled_filetypes = { statusline = { "neo-tree" }, winbar = { "neo-tree" } },
					ignore_focus = { "neo-tree" },
				},
				sections = {
					lualine_c = { { "filename", file_status = true, path = 1 } },
				},
				extensions = { "fugitive", "neo-tree" },
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		config = function()
			require("catppuccin").setup({
				integrations = {
					-- flash = true,
					hop = true,
					gitsigns = true,
					cmp = true,
					mini = true,
					neotree = false,
					mason = true,
					treesitter = true,
					indent_blankline = {
						enabled = true,
					},
					native_lsp = { enabled = true },
					illuminate = {
						enabled = true,
						lsp = true,
					},
					window_picker = true,
				},
			})
		end,
	},
	-- { "RRethy/vim-illuminate" },
	{
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
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
			require("mini.splitjoin").setup({})
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
			-- disable <C-s>
			vim.keymap.del("n", "<C-s>")
			vim.keymap.del("v", "<C-s>")
			vim.keymap.del("i", "<C-s>")
		end,
	},
	{
		"junegunn/fzf",
		build = "./install --bin",
	},
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
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
				-- winopts = {
				--     border = false,
				--     preview = {
				--         border = false,
				--     },
				-- },
			})
		end,
		keys = {
			{ "<leader><leader>", "<cmd>:FzfLua<cr>" },
			{ "<leader>f", "<cmd>:FzfLua files<CR>" },
			{ "<leader>g", "<cmd>:FzfLua live_grep<CR>" },
			{ "<leader>G", "<cmd>:FzfLua git_status<CR>" },
			{ "<leader>s", "<cmd>:FzfLua lsp_document_symbols<CR>" },
			{ "<leader>cc", "<cmd>:FzfLua files cwd=~/.config<CR>" },
			-- { "<leader>e", "<cmd>:FzfLua files cwd=~/src/gitlab.com/corelight/engineering/elysium/<CR>" },
			{ "<leader>b", "<cmd>:FzfLua buffers<cr>" },
			{ "<leader>z", "<cmd>:FzfLua<CR>" },
			{ '<leader>"', "<cmd>:FzfLua registers<cr>" },
			{ "<leader>'", "<cmd>:FzfLua marks<cr>" },
			{ "<C-r>", "<cmd>:FzfLua registers<cr>", mode = "i" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ -- Optional
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" }, -- Required
			{ "hrsh7th/cmp-path" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "jose-elias-alvarez/null-ls.nvim" },
			{ "jayp0521/mason-null-ls.nvim" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			local lsp = require("lsp-zero").preset({})

			lsp.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp.default_keymaps({ buffer = bufnr })
				local opts = { buffer = bufnr }

				vim.keymap.set("n", "<leader>F", function()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end, opts)

				vim.keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = true })
				vim.keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = true })
				vim.keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = true })
				vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)

				-- lsp.buffer_autoformat()
			end)

			lsp.set_sign_icons({
				error = "✘",
				warn = "▲",
				hint = "⚑",
				info = "»",
			})

			lsp.configure("yamlls", {
				settings = {
					yaml = {
						format = {
							enable = false,
						},
						keyOrdering = false,
					},
				},
			})

			lsp.setup()

			require("mason-null-ls").setup()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.shfmt,
					null_ls.builtins.formatting.stylua,
				},
			})

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					-- confirm completion
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					-- scroll up and down the documentation window
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<Tab>"] = cmp_action.tab_complete(),
					["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
				}),
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip", keyword_length = 4 },
				},
			})

		end,
	},
	{
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
			require("window-picker").setup({
				fg_color = "#eff1f5",
			})
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
		opts = { theme = "gruvbox" },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		config = function()
			require("trouble").setup({})
		end,
		keys = {
			{ "<leader>t", "<cmd>:TroubleToggle<cr>" },
		},
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
		keys = {
			{ "<leader>Gc", "<cmd>:GitConflictListQf<cr>" },
		},
	},
})

--- options
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"
vim.opt.linebreak = true
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
-- vim.opt.winblend = 30
vim.opt.wrap = false

-- keymaps
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>lu", "<cmd>:Lazy update<cr>", opts)

vim.api.nvim_set_keymap("n", "cy", [["*y]], opts)
-- vim.api.nvim_set_keymap("n", "cp", [["*p]], opts)

vim.api.nvim_set_keymap("v", "cy", [["*y]], opts)
-- vim.api.nvim_set_keymap("v", "cp", [["*p]], opts)

vim.api.nvim_set_keymap("n", "H", ":tabprev<cr>", opts)
vim.api.nvim_set_keymap("n", "L", ":tabnext<cr>", opts)

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- trail whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

-- disable inline diagnostics
vim.diagnostic.config({
	virtual_text = false,
})

vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")
