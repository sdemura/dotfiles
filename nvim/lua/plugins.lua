---@diagnostic disable: undefined-global, lowercase-global
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	print("Installing packer. Restart Neovim")
end

-- start packer
vim.cmd([[packadd packer.nvim]])

-- Reload Neovim whenever you save the plugins.lua file.
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- Only move on if we can require Packer.
local ok, packer = pcall(require, "packer")
if not ok then
	return
end

packer.init({})

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		use("kyazdani42/nvim-web-devicons")
		use("neovim/nvim-lspconfig")
		use({
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		})
		use({
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup()
			end,
		})

		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use({
			"nvim-telescope/telescope.nvim",
			tag = "0.1.0",
			config = function()
				local telescope = require("telescope")
				local actions = require("telescope.actions")

				telescope.setup({
					defaults = {
						mappings = {
							i = {
								["<C-c>"] = actions.close,
								["<Esc>"] = actions.close,

								["<C-j>"] = actions.cycle_history_next,
								["<C-k>"] = actions.cycle_history_prev,

								["<C-n>"] = actions.move_selection_next,
								["<C-p>"] = actions.move_selection_previous,

								["<Down>"] = actions.move_selection_next,
								["<Up>"] = actions.move_selection_previous,

								["<CR>"] = actions.select_default,
								["<C-x>"] = actions.select_horizontal,
								["<C-v>"] = actions.select_vertical,
								["<C-t>"] = actions.select_tab,

								["<C-u>"] = actions.preview_scrolling_up,
								["<C-d>"] = actions.preview_scrolling_down,

								["<PageUp>"] = actions.results_scrolling_up,
								["<PageDown>"] = actions.results_scrolling_down,

								["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
								["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
								["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
								["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
								["<C-l>"] = actions.complete_tag,
							},

							n = {
								["<C-c>"] = actions.close,
								["<Esc>"] = actions.close,

								["<CR>"] = actions.select_default,
								["<C-x>"] = actions.select_horizontal,
								["<C-v>"] = actions.select_vertical,
								["<C-t>"] = actions.select_tab,

								["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
								["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
								["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
								["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

								["j"] = actions.move_selection_next,
								["k"] = actions.move_selection_previous,
								["H"] = actions.move_to_top,
								["M"] = actions.move_to_middle,
								["L"] = actions.move_to_bottom,

								["<Down>"] = actions.move_selection_next,
								["<Up>"] = actions.move_selection_previous,
								["gg"] = actions.move_to_top,
								["G"] = actions.move_to_bottom,

								["<C-u>"] = actions.preview_scrolling_up,
								["<C-d>"] = actions.preview_scrolling_down,

								["<PageUp>"] = actions.results_scrolling_up,
								["<PageDown>"] = actions.results_scrolling_down,
							},
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
				require("telescope").load_extension("fzf")
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"yaml",
						"go",
						"hcl",
						"lua",
						"python",
						"bash",
						"markdown",
						"dockerfile",
						"json",
					},
					highlight = { enable = true, use_languagetree = true },
				})
			end,
		})

		use({
			"phaazon/hop.nvim",
			branch = "v2", -- optional but strongly recommended
			config = function()
				-- you can configure Hop the way you like here; see :h hop-config
				require("hop").setup({})
			end,
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.formatting.shfmt,
						null_ls.builtins.formatting.black,
						null_ls.builtins.formatting.isort,
						null_ls.builtins.formatting.prettier,
						null_ls.builtins.diagnostics.yamllint,
						null_ls.builtins.diagnostics.shellcheck,
						null_ls.builtins.diagnostics.hadolint,
						diagnostics_format = "[#{c}] #{m} (#{s})",
					},
				})
			end,
		})

		use({
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup()
			end,
		})

		use({
			"windwp/nvim-autopairs",
			config = function()
				require("nvim-autopairs").setup({
					ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
				})
			end,
		})

		use({
			"echasnovski/mini.nvim",
			branch = "stable",
			config = function()
				require("mini.ai").setup()
				require("mini.trailspace").setup()
				require("mini.comment").setup()
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			config = function()
				require("lualine").setup({
					options = {
						globalstatus = false,
						component_separators = { right = "|" },
						section_separators = { left = "", right = "" },
						disabled_filetypes = {
							statusline = {
								"aerial",
								"neo-tree",
							},
							winbar = {
								"aerial",
								"neo-tree",
							},
						},
					},
					sections = {
						lualine_a = { { "mode", separator = { right = "" } } },
						lualine_c = {
							{
								"filename",
								file_status = true,
								path = 1,
							},
						},
						lualine_x = { "aerial" },
						lualine_z = { { "location", separator = { left = "" } } },
					},
				})
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		})

		use({ "tpope/vim-fugitive" })
		use({ "tpope/vim-unimpaired" })

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
		})

		use({
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v2.x",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("neo-tree").setup({
					popup_border_style = "rounded",
					close_if_last_window = true,
					filesystem = {
						window = {
							mappings = {
								["s"] = "none",
							},
						},
						filtered_items = {
							hide_gitignored = false,
							hide_dotfiles = false,
						},
					},
				})
			end,
		})

		use({
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		})

		use({
			"akinsho/git-conflict.nvim",
			tag = "*",
			config = function()
				require("git-conflict").setup()
			end,
		})

		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					show_current_context = true,
				})
			end,
		})

		use({ "catppuccin/nvim", as = "catppuccin" })

		use({
			"akinsho/toggleterm.nvim",
			tag = "*",
			config = function()
				require("toggleterm").setup({ open_mapping = [[<c-\>]] })
			end,
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,

	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})
