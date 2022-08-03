local config = {

	-- Configure AstroNvim updates
	updater = {
		remote = "origin", -- remote to use
		channel = "nightly", -- "stable" or "nightly"
		version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "main", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		-- remotes = { -- easily add new remotes to track
		--   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
		--   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
		--   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
		-- },
	},

	-- Set colorscheme
	-- colorscheme = "default_theme",
	colorscheme = "nordfox",

	-- Override highlight groups in any theme
	highlights = {
		-- duskfox = { -- a table of overrides
		--   Normal = { bg = "#000000" },
		-- },
		default_theme = function(highlights) -- or a function that returns one
			local C = require("default_theme.colors")

			highlights.Normal = { fg = C.fg, bg = C.bg }
			return highlights
		end,
	},

	-- set vim options here (vim.<first_key>.<second_key> =  value)
	options = {
		opt = {
			relativenumber = true, -- sets vim.opt.relativenumber
			wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" },
		},
		g = {
			mapleader = " ", -- sets vim.g.mapleader
		},
	},

	-- Default theme configuration
	default_theme = {
		diagnostics_style = { italic = true },
		-- Modify the color table
		colors = {
			fg = "#abb2bf",
		},
		plugins = { -- enable or disable extra plugin highlighting
			aerial = true,
			beacon = false,
			bufferline = true,
			dashboard = true,
			highlighturl = true,
			hop = true,
			indent_blankline = true,
			lightspeed = false,
			["neo-tree"] = true,
			notify = true,
			["nvim-tree"] = false,
			["nvim-web-devicons"] = true,
			rainbow = true,
			symbols_outline = false,
			telescope = true,
			vimwiki = false,
			["which-key"] = true,
		},
	},

	-- Disable AstroNvim ui features
	ui = {
		nui_input = true,
		telescope_select = true,
	},

	-- Configure plugins
	plugins = {
		-- Add plugins, the packer syntax without the "use"
		init = {
			-- You can disable default plugins as follows:
			-- ["goolord/alpha-nvim"] = { disable = true },
			["declancm/cinnamon.nvim"] = { disable = true },

			-- You can also add new plugins here as well:
			-- { "andweeb/presence.nvim" },
			{
				"ray-x/lsp_signature.nvim",
				event = "BufRead",
				config = function()
					require("lsp_signature").setup()
				end,
			},
			{
				"phaazon/hop.nvim",
				config = function()
					require("hop").setup()
				end,
			},
			{ "EdenEast/nightfox.nvim" },
			{
				"karb94/neoscroll.nvim",
				config = function()
					require("neoscroll").setup()
				end,
			},
			{
				"luukvbaal/stabilize.nvim",
				config = function()
					require("stabilize").setup({
						nested = "QuickFixCmdPost,DiagnosticChanged *",
					})
				end,
			},
			{
				"kylechui/nvim-surround",
				config = function()
					require("nvim-surround").setup()
				end,
			},
			{
				"echasnovski/mini.nvim",
				config = function()
					require("mini.ai").setup()
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-context",
				config = function()
					require("treesitter-context").setup()
				end,
			},
			{
				"tpope/vim-fugitive",
			},
			{
				"b0o/incline.nvim",
				config = function()
					require("incline").setup()
				end,
			},
		},
		-- All other entries override the setup() call for default plugins
		["telescope"] = function()
			local telescope = require("telescope")
			local telescope_actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					layout_config = { prompt_position = "bottom" },
				},
				mappings = {
					i = {
						["<C-j>"] = telescope_actions.cycle_history_next,
						["<C-k>"] = telescope_actions.cycle_history_prev,

						["<C-n>"] = telescope_actions.move_selection_next,
						["<C-p>"] = telescope_actions.move_selection_previous,
					},
				},
				pickers = {
					find_files = {
						find_command = {
							"fd",
							".",
							"--type",
							"file",
							"--hidden",
							"--strip-cwd-prefix",
							"--exclude",
							".git",
						},
					},
					live_grep = {
						additional_args = function(opts)
							return { "--hidden" }
						end,
						glob_pattern = "!.git",
					},
				},
			})
		end,
		-- All other entries override the setup() call for default plugins
		["null-ls"] = function(config)
			local null_ls = require("null-ls")
			-- Check supported formatters and linters
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
			config.sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.diagnostics.yamllint,
				null_ls.builtins.diagnostics.shellcheck,
				null_ls.builtins.diagnostics.hadolint,
			}
			-- set up null-ls's on_attach function
			config.on_attach = function(client)
				-- NOTE: You can remove this on attach function to disable format on save
				if client.resolved_capabilities.document_formatting then
					vim.api.nvim_create_autocmd("BufWritePre", {
						desc = "Auto format before save",
						pattern = "<buffer>",
						callback = vim.lsp.buf.formatting_sync,
					})
				end
			end
			return config -- return final config table
		end,
		treesitter = {
			ensure_installed = { "lua", "go", "python", "bash", "hcl" },
			highlight = { enable = true, use_languagetree = true },
		},
		["nvim-lsp-installer"] = {
			ensure_installed = { "sumneko_lua", "gopls", "pyright", "bash-language-server" },
		},
		packer = {
			compile_path = vim.fn.stdpath("data") .. "/packer_compiled.lua",
		},
	},

	-- LuaSnip Options
	luasnip = {
		-- Add paths for including more VS Code style snippets in luasnip
		vscode_snippet_paths = {},
		-- Extend filetypes
		filetype_extend = {
			javascript = { "javascriptreact" },
		},
	},

	-- Modify which-key registration
	["which-key"] = {
		-- Add bindings
		register_mappings = {
			-- first key is the mode, n == normal mode
			n = {
				-- second key is the prefix, <leader> prefixes
				["<leader>"] = {
					-- which-key registration table for normal mode, leader prefix
					-- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
				},
			},
		},
	},

	-- CMP Source Priorities
	-- modify here the priorities of default cmp sources
	-- higher value == higher priority
	-- The value can also be set to a boolean for disabling default sources:
	-- false == disabled
	-- true == 1000
	cmp = {
		source_priority = {
			nvim_lsp = 1000,
			luasnip = 750,
			buffer = 500,
			path = 250,
		},
	},

	-- Extend LSP configuration
	lsp = {
		-- enable servers that you already have installed without lsp-installer
		servers = {
			-- "pyright"
		},
		-- easily add or disable built in mappings added during LSP attaching
		mappings = {
			n = {
				-- ["<leader>lf"] = false -- disable formatting keymap
			},
		},
		-- add to the server on_attach function
		-- on_attach = function(client, bufnr)
		-- end,

		-- override the lsp installer server-registration function
		-- server_registration = function(server, opts)
		--   require("lspconfig")[server].setup(opts)
		-- end,

		-- Add overrides for LSP server settings, the keys are the name of the server
		["server-settings"] = {
			-- example for addings schemas to yamlls
			-- yamlls = {
			--   settings = {
			--     yaml = {
			--       schemas = {
			--         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
			--         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			--         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
			--       },
			--     },
			--   },
			-- },
		},
	},

	-- Diagnostics configuration (for vim.diagnostics.config({}))
	diagnostics = {
		virtual_text = false,
		underline = true,
		signs = true,
		float = {
			border = "single",
			format = function(diagnostic)
				return string.format(
					"%s (%s) [%s]",
					diagnostic.message,
					diagnostic.source,
					diagnostic.code or diagnostic.user_data.lsp.code
				)
			end,
		},
	},

	mappings = {
		-- first key is the mode
		n = {
			-- second key is the lefthand side of the map
			["f"] = {
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
			},
			["F"] = {
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
			},
			["t"] = {
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
			},
			["T"] = {
				"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>",
			},
			["s"] = { ":HopWord<cr>", desc = "Hopword" },
			["]b"] = { ":BufferLineCycleNext<CR>", desc = "Next in bufferline" },
			["[b"] = { ":BufferLineCyclePrev<CR>", desc = "Previous in bufferline" },

			["]t"] = { "gT", desc = "Previous Tab" },
			["[t"] = { "gt", desc = "Next Tab" },
			["<leader>r"] = { ":Neotree reveal<cr>", desc = "Reveal file in editor" },
			["<leader>c"] = { ":e ~/.config/astronvim/lua/user/init.lua<cr>", desc = "Edit AstroNvim Config File" },
		},
		t = {
			-- setting a mapping to false will disable it
			-- ["<esc>"] = false,
		},
	},

	-- This function is run last
	-- good place to configuring augroups/autocommands and custom filetypes
	polish = function()
		-- Set key binding
		-- Set autocommands
		vim.api.nvim_create_augroup("packer_conf", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			desc = "Sync packer after modifying plugins.lua",
			group = "packer_conf",
			pattern = "plugins.lua",
			command = "source <afile> | PackerSync",
		})

		-- Set up custom filetypes
		vim.filetype.add({
			extension = {
				hcl = "terraform",
			},
			-- filename = {
			--   ["Foofile"] = "fooscript",
			-- },
			-- pattern = {
			--   ["~/%.config/foo/.*"] = "fooscript",
			-- },
		})
		vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}]])
	end,

	header = {
		"██╗      ██████╗  ██████╗ ██████╗ ██████╗  █████╗  ██████╗██╗  ██╗███████╗███████╗ █████╗ ███╗   ██╗",
		"██║     ██╔═══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔════╝██╔══██╗████╗  ██║",
		"██║     ██║   ██║██║   ██║██████╔╝██████╔╝███████║██║     █████╔╝ ███████╗█████╗  ███████║██╔██╗ ██║",
		"██║     ██║   ██║██║   ██║██╔═══╝ ██╔══██╗██╔══██║██║     ██╔═██╗ ╚════██║██╔══╝  ██╔══██║██║╚██╗██║",
		"███████╗╚██████╔╝╚██████╔╝██║     ██████╔╝██║  ██║╚██████╗██║  ██╗███████║███████╗██║  ██║██║ ╚████║",
		"╚══════╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝",
	},
}

return config
