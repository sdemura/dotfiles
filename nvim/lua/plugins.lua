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

return require("packer").startup(function(use)
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
    -- Lua
    -- use({
    -- 	"folke/which-key.nvim",
    -- 	config = function()
    -- 		require("which-key").setup({
    -- 			-- your configuration comes here
    -- 			-- or leave it empty to use the default settings
    -- 			-- refer to the configuration section below
    -- 		})
    -- 	end,
    -- })

    use("sainnhe/everforest")

    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-c>"] = actions.close,
                            ["<Esc>"] = actions.close,
                        },
                        n = {
                            ["<C-c>"] = actions.close,
                            ["<Esc>"] = actions.close,
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
                ensure_installed = { "yaml", "go", "hcl", "lua", "python", "bash", "markdown", "dockerfile", "json" },
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
            local navic = require("nvim-navic")

            require("lualine").setup({
                options = {
                    globalstatus = true,
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
                winbar = {
                    lualine_c = { { navic.get_location, cond = navic.is_available } },
                    lualine_z = {
                        {
                            "filename",
                            file_status = true,
                            path = 1,
                        },
                    },
                },
                inactive_winbar = {
                    lualine_z = {
                        {
                            "filename",
                            file_status = true,
                            path = 1,
                        },
                    },
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

    use({
        "tiagovla/scope.nvim",
        config = function()
            require("scope").setup()
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
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup()
        end,
    })

    use({
        "antoinemadec/FixCursorHold.nvim",
        config = function()
            vim.g.cursorhold_updatetime = 100
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

    -- init.lua
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
        "SmiteshP/nvim-navic",
        config = function()
            require("nvim-navic").setup({
                highlight = false,
            })
        end,
    })

    if packer_bootstrap then
        require("packer").sync()
    end
end)
