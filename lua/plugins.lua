---@diagnostic disable: undefined-global, lowercase-global

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
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
if not ok then return end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    -- use("Glench/Vim-Jinja2-Syntax")
    use({ 'kyazdani42/nvim-web-devicons', config = function() require('nvim-web-devicons').setup() end })
    use({
        "folke/which-key.nvim",
        config = function() require("which-key").setup({}) end,
    })
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-path")

    use({ "L3MON4D3/LuaSnip" })
    use("saadparwaiz1/cmp_luasnip")

    use({
        "hrsh7th/nvim-cmp",
        requires = { "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                preselect = cmp.PreselectMode.None,
                snippet = {
                    expand = function(args) require("luasnip").lsp_expand(args.body) end,
                },
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "luasnip" },
                },
            })
        end,
    })

    use("lewis6991/impatient.nvim")

    use("nathom/filetype.nvim")

    use({
        "williamboman/nvim-lsp-installer",
        {
            "neovim/nvim-lspconfig",
            config = function()
                require("nvim-lsp-installer").setup()
                -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                local opts = { noremap = true, silent = true }
                vim.api.nvim_set_keymap(
                    "n",
                    "<space>e",
                    "<cmd>lua vim.diagnostic.open_float()<CR>",
                    opts
                )
                vim.api.nvim_set_keymap(
                    "n",
                    "[d",
                    "<cmd>lua vim.diagnostic.goto_prev()<CR>",
                    opts
                )
                vim.api.nvim_set_keymap(
                    "n",
                    "]d",
                    "<cmd>lua vim.diagnostic.goto_next()<CR>",
                    opts
                )
                vim.api.nvim_set_keymap(
                    "n",
                    "<space>q",
                    "<cmd>lua vim.diagnostic.setloclist()<CR>",
                    opts
                )

                local on_attach = function(client, bufnr)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.api.nvim_buf_set_option(
                        bufnr,
                        "omnifunc",
                        "v:lua.vim.lsp.omnifunc"
                    )

                    -- Mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local bufopts =
                    { noremap = true, silent = true, buffer = bufnr }
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                    vim.keymap.set(
                        "n",
                        "gi",
                        vim.lsp.buf.implementation,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<C-k>",
                        vim.lsp.buf.signature_help,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<space>wa",
                        vim.lsp.buf.add_workspace_folder,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<space>wr",
                        vim.lsp.buf.remove_workspace_folder,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<space>wl",
                        function()
                            print(
                                vim.inspect(
                                    vim.lsp.buf.list_workspace_folders()
                                )
                            )
                        end,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<space>D",
                        vim.lsp.buf.type_definition,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<space>rn",
                        vim.lsp.buf.rename,
                        bufopts
                    )
                    vim.keymap.set(
                        "n",
                        "<space>ca",
                        vim.lsp.buf.code_action,
                        bufopts
                    )
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                    vim.keymap.set(
                        "n",
                        "<space>f",
                        vim.lsp.buf.formatting,
                        bufopts
                    )

                    -- -- aerials.nvim
                    local aerial = require("aerial")
                    aerial.setup({
                        show_guides = true,
                    })
                    aerial.on_attach(client, bufnr)
                    require("lsp_signature").on_attach({
                        handler_opts = { border = "none" },
                        hint_enable = false,
                    })
                end

                -- Add additional capabilities supported by nvim-cmp
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

                -- setup automatic attach for certain lsp's
                local lspconfig = require("lspconfig")
                lspconfig.gopls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
                lspconfig.pyright.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
                lspconfig.jsonls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
                lspconfig.bashls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
                lspconfig.dockerls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
                lspconfig.sumneko_lua.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            version = "LuaJIT",
                            diagnostics = {
                                globals = {
                                    "vim",
                                    "describe",
                                    "it",
                                    "before_each",
                                    "after_each",
                                    "pending",
                                },
                            },
                        },
                    },
                })
                lspconfig.yamlls.setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                        yaml = {
                            schemas = {
                                ["https://json.schemastore.org/taskfile.json"] = "Taskfile.yaml",
                            },
                        },
                    },
                })
            end,
        },
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.shfmt,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.diagnostics.yamllint,
                    null_ls.builtins.diagnostics.shellcheck,
                    null_ls.builtins.diagnostics.hadolint,
                    diagnostics_format = "[#{c}] #{m} (#{s})",
                },
            })
        end,
    })

    use("sainnhe/everforest")
    use("shumphrey/fugitive-gitlab.vim")
    use("tpope/vim-fugitive")
    use("wellle/targets.vim")
    use({
        "stevearc/aerial.nvim",
        config = function() require("aerial").setup() end,
    })
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("trouble").setup() end,
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "nvim-telescope/telescope-ui-select.nvim" })
    use({
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = { ["<esc>"] = actions.close },
                        n = { ["<esc>"] = actions.close },
                    },
                    file_ignore_patterns = { ".git/", ".vscode/", ".pyenv/" },
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
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
                        },
                    },
                    live_grep = {
                        additional_args = function(opts) return { "--hidden" } end,
                        glob_pattern = "!.git",
                    },
                },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("ui-select")
        end,
    })
    -- use({
    --     "s1n7ax/nvim-window-picker",
    --     tag = "1.*",
    --     config = function()
    --         require("window-picker").setup({
    --             autoselect_one = true,
    --             include_current = false,
    --             selection_chars = "ABCDEFGHIJKLMNOP",
    --             filter_rules = {
    --                 -- filter using buffer options
    --                 bo = {
    --                     -- if the file type is one of following, the window will be ignored
    --                     filetype = {
    --                         "aerial",
    --                         "neo-tree",
    --                         "neo-tree-popup",
    --                         "notify",
    --                         "quickfix",
    --                         "toggleterm",
    --                         "qf",
    --                         "fugitiveblame",
    --                     },
    --
    --                     -- if the buffer type is one of following, the window will be ignored
    --                     buftype = { "terminal", "quickfix" },
    --                 },
    --             },
    --
    --             other_win_hl_color = "#f4a261",
    --             fg_color = "#dfdfe0",
    --         })
    --     end,
    -- })

    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            -- "s1n7ax/nvim-window-picker",
        },
        config = function()
            require("neo-tree").setup({
                popup_border_style = "rounded",
                close_if_last_window = true,
                -- window = {
                --     mappings = {
                --         ["<cr>"] = "open_with_window_picker",
                --     },
                -- },
                filesystem = {
                    filtered_items = {
                        hide_gitignored = false,
                        hide_dotfiles = false,
                    },
                },
            })
        end,
    })
    use({
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end,
    })
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = "",
                    component_separators = "",
                },
                extensions = {
                    "aerial",
                    "fugitive",
                    "neo-tree",
                    "quickfix",
                    "quickfix",
                    "toggleterm",
                },
                sections = {
                    lualine_b = {
                        "branch",
                        { "diff", },
                        { "diagnostics", },
                    },
                    lualine_c = {
                        {
                            "filename",
                            file_status = true, -- displays file status (readonly status, modified status)
                            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
                        },
                    },
                    lualine_x = { "aerial" },
                },
            })
        end,
    })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "dockerfile",
                    "go",
                    "hcl",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "python",
                    "toml",
                    "vim",
                    "yaml",
                },
                highlight = { enable = true },
            })
        end,
    })

    use({
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                terminal_mappings = true,
                shade_terminals = true,
                -- 	direction = "sp",
            })
        end,
    })


    use("EdenEast/nightfox.nvim")

    use({
        "bennypowers/nvim-regexplainer",
        requires = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = function() require("regexplainer").setup() end,
    })

    -- use("mfussenegger/nvim-dap")
    -- use("mfussenegger/nvim-dap-python")

    use({
        "antoinemadec/FixCursorHold.nvim",
        config = function() vim.g.cursorhold_updatetime = 100 end,
    })

    use({
        "echasnovski/mini.nvim",
        branch = "stable",
        config = function()
            require("mini.trailspace").setup({})
            -- require("mini.surround").setup({})
        end,
    })

    use({ 'kylechui/nvim-surround', config = function() require("nvim-surround").setup {} end })

    use({
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup({}) end,
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({ show_current_context = true })
        end,
    })
    -- using packer.nvim
    -- use({
    --     "akinsho/bufferline.nvim",
    --     tag = "v2.*",
    --     requires = "kyazdani42/nvim-web-devicons",
    --     config = function()
    --         require("bufferline").setup({
    --             options = {
    --                 offsets = {
    --                     {
    --                         filetype = "nvimtree",
    --                         text = "Files",
    --                         text_align = "left",
    --                     },
    --                     {
    --                         filetype = "neo-tree",
    --                         text = "Files",
    --                         text_align = "left",
    --                     },
    --                     {
    --                         filetype = "aerial",
    --                         text = "Symbols",
    --                         text_align = "left",
    --                     },
    --                 },
    --                 -- separator_style = "thick",
    --                 -- show_buffer_close_icons = false,
    --                 enforce_regular_tabs = true,
    --             },
    --         })
    --     end,
    -- })
    use({
        "windwp/nvim-autopairs",
        config = function()
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            require("nvim-autopairs").setup({
                ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
                enable_check_bracket_line = false,
                check_ts = true,
                ts_config = {
                    lua = { "string", "source" },
                    javascript = { "string", "template_string" },
                    java = false,
                },
                disable_filetype = { "TelescopePrompt", },
            })
        end,
    })
    use({
        "tiagovla/scope.nvim",
        config = function() require("scope").setup({}) end,
    })
    use({
        "rcarriga/nvim-notify",
        config = function() vim.notify = require("notify") end,
    })
    use("stevearc/stickybuf.nvim")
    use({
        "phaazon/hop.nvim",
        config = function() require("hop").setup({}) end,
    })
    -- use({
    --     "mizlan/iswap.nvim",
    --     config = function() require("iswap").setup({}) end,
    -- })
    use({
        "luukvbaal/stabilize.nvim",
        config = function()
            require("stabilize").setup({
                nested = "QuickFixCmdPost,DiagnosticChanged *",
            })
        end,
    })
    use({
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup({ hi_parameter = "IncSearch" })
        end,
    })
    use({ "ray-x/go.nvim", config = function() require("go").setup({}) end })
    use("ray-x/guihua.lua")
    use({
        "stevearc/dressing.nvim",
        config = function() require("dressing").setup({}) end,
    })

    use { 'akinsho/git-conflict.nvim', config = function()
        require('git-conflict').setup()
    end }

    use({ 'karb94/neoscroll.nvim', config = function() require('neoscroll').setup() end })
    use({ 'nvim-treesitter/nvim-treesitter-textobjects', config = function()
        require('nvim-treesitter.configs').setup {
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },

        }
    end })
    use({ "b0o/incline.nvim", config = function() require('incline').setup {} end })

    if packer_bootstrap then require("packer").sync() end
end)
