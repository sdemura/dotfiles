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
    { "tpope/vim-fugitive" },
    { "tpope/vim-unimpaired" },
    { "tpope/vim-eunuch" },
    {
        "ray-x/go.nvim",
        dependencies = { "ray-x/guihua.lua" },
        config = function()
            require("go").setup({
                max_line_len = 100,
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ":lua require('go.install').update_all_sync()",
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "S",
                mode = { "n", "o", "x" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc =
                "Remote Flash"
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
                colored_indent_levels = false,
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
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
                    mini = true,
                    neotree = false,
                    mason = true,
                    treesitter = true,
                    indent_blankline = {
                        enabled = true,
                    },
                    native_lsp = { enabled = true },
                    -- barbecue = {
                    --     bold_basename = true,
                    -- }
                },
            })
        end,
    },
    { "RRethy/vim-illuminate" },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            -- require("mini.comment").setup({})
            require("mini.ai").setup({})
            require("mini.splitjoin").setup({})
            require("mini.basics").setup({
                options = {
                    basic = false,
                    extra_ui = false,
                },
                mappings = {
                    basic = false,
                    move_with_alt = false,
                },
                autocommands = {
                    basic = true,
                    relnum_in_visual_mode = true,
                },
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
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
                    rg_opts =
                    [[--hidden --column -g "!.git" --line-number --no-heading --color=always --smart-case --max-columns=4096]],
                },
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
            })
        end,
        keys = {
            { "<leader>f",  "<cmd>:FzfLua files<CR>" },
            { "<leader>g",  "<cmd>:FzfLua live_grep<CR>" },
            { "<leader>s",  "<cmd>:FzfLua lsp_document_symbols<CR>" },
            { "<leader>cc", "<cmd>:FzfLua files cwd=~/.config<CR>" },
            -- { "<leader>e", "<cmd>:FzfLua files cwd=~/src/gitlab.com/corelight/engineering/elysium/<CR>" },
            { "<leader>b",  "<cmd>:FzfLua buffers<cr>" },
            { "<leader>z",  "<cmd>:FzfLua<CR>" },
            { '<leader>"',  "<cmd>:FzfLua registers<cr>" },
            { "<leader>'",  "<cmd>:FzfLua marks<cr>" },
            { "<C-r>",      "<cmd>:FzfLua registers<cr>",           mode = "i" },
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
            {                            -- Optional
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" }, -- Optional

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },     -- Required
            { "hrsh7th/cmp-nvim-lsp" }, -- Required
            { "hrsh7th/cmp-buffer" },   -- Required
            { "hrsh7th/cmp-path" },     -- Required
            { "L3MON4D3/LuaSnip" },     -- Required
        },
        config = function()
            local lsp = require("lsp-zero").preset({})

            lsp.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp.default_keymaps({ buffer = bufnr })
                local opts = { buffer = bufnr }

                vim.keymap.set({ 'n', 'x' }, '<leader>F', function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                end, opts)

                vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { buffer = true })
                vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = true })
                vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = true })

                lsp.buffer_autoformat()
            end)
            --
            -- lsp.configure("gopls", {
            require('lspconfig').gopls.setup({
                settings = {
                    gopls = { gofumpt = true }
                }
            })

            lsp.set_sign_icons({
                error = '✘',
                warn = '▲',
                hint = '⚑',
                info = '»'
            })

            -- lsp.format_on_save({
            --     format_opts = {
            --         async      = false,
            --         timeout_ms = 10000,
            --     },
            --     servers = {
            --         ['gopls'] = { 'go' }
            --     }
            -- })

            lsp.setup()

            local cmp = require('cmp')

            cmp.setup({
                preselect = 'item',
                mapping = {
                    ['<tab>'] = cmp.mapping.confirm({ select = false }),
                },
                sources = {
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'buffer',  keyword_length = 3 },
                    { name = 'luasnip', keyword_length = 2 },
                },
            })

            -- other stuff
            -- local cmp = require("cmp")
            -- local cmp_action = require('lsp-zero').cmp_action()
            --
            -- cmp.setup({
            --     ["<C-p>"] = cmp_action.select_prev_item(),
            --     ["<C-n>"] = cmp_action.select_next_item(),
            --     ["<C-d>"] = cmp_action.scroll_docs(-4),
            --     ["<C-f>"] = cmp_action.scroll_docs(4),
            --     ["<C-Space>"] = cmp_action.complete(),
            --     ["<C-e>"] = cmp_action.close(),
            --     ["<C-y>"] = cmp_action.confirm({ select = true }),
            --     ["<tab>"] = cmp_action.confirm({ select = true }),
            -- })
        end,
    },
    -- {
    -- 	"VonHeikemen/lsp-zero.nvim",
    -- 	branch = "v1.x",
    -- 	lazy = false,
    -- 	dependencies = {
    -- 		-- LSP Support
    -- 		{ "neovim/nvim-lspconfig" },
    -- 		{ "williamboman/mason.nvim" },
    -- 		{ "williamboman/mason-lspconfig.nvim" },
    -- 		{ "jose-elias-alvarez/null-ls.nvim" },
    -- 		{ "jayp0521/mason-null-ls.nvim" },
    --
    -- 		-- Autocompletion
    -- 		{ "hrsh7th/nvim-cmp" },
    -- 		{ "hrsh7th/cmp-buffer" },
    -- 		{ "hrsh7th/cmp-path" },
    -- 		{ "saadparwaiz1/cmp_luasnip" },
    -- 		{ "hrsh7th/cmp-nvim-lsp" },
    -- 		{ "hrsh7th/cmp-nvim-lua" },
    --
    -- 		-- Snippets
    -- 		{ "L3MON4D3/LuaSnip" },
    -- 		-- Snippet Collection (Optional)
    -- 		{ "rafamadriz/friendly-snippets" },
    --
    -- 		-- Signature support
    -- 		{ "ray-x/lsp_signature.nvim" },
    -- 	},
    -- 	config = function()
    -- 		local lsp = require("lsp-zero")
    -- 		lsp.preset("recommended")
    --
    -- 		lsp.set_preferences({
    -- 			set_lsp_keymaps = { omit = { "<F2>", "<F4>", "gl" } },
    -- 		})
    --
    -- 		lsp.on_attach(function(client, bufnr)
    -- 			local map = function(mode, lhs, rhs)
    -- 				local opts = { remap = false, buffer = bufnr }
    -- 				vim.keymap.set(mode, lhs, rhs, opts)
    -- 			end
    --
    -- 			-- LSP actions
    -- 			map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
    -- 			map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    -- 			map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    -- 			map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    -- 			map("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
    -- 			map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    -- 			map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    -- 			map("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
    -- 			map("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    -- 			map("x", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")
    -- 			map("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<cr>")
    --
    -- 			-- Diagnostics
    -- 			map("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<cr>")
    -- 			map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
    -- 			map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
    --
    -- 			-- Signature
    -- 			require("lsp_signature").on_attach({
    -- 				hint_enable = false,
    -- 				noice = false,
    -- 				doc_lines = 0,
    -- 			}, bufnr)
    -- 		end)
    --
    -- 		lsp.configure("gopls", {
    -- 			on_attach = function(client, bufnr)
    -- 				vim.api.nvim_create_autocmd("BufWritePre", {
    -- 					desc = "Auto format before save",
    -- 					pattern = "<buffer>",
    -- 					callback = function()
    -- 						require("go.format").goimport()
    -- 					end,
    -- 				})
    -- 			end,
    -- 		})
    --
    -- 		lsp.configure("yamlls", {
    -- 			settings = {
    -- 				yaml = {
    -- 					format = {
    -- 						printWidth = 100,
    -- 						bracketSpacing = false,
    -- 					},
    -- 					keyOrdering = false,
    -- 				},
    -- 			},
    -- 		})
    --
    -- 		local cmp = require("cmp")
    -- 		lsp.setup_nvim_cmp({
    -- 			-- preselect = "none",
    -- 			mapping = {
    -- 				["<C-p>"] = cmp.mapping.select_prev_item(),
    -- 				["<C-n>"] = cmp.mapping.select_next_item(),
    -- 				["<C-d>"] = cmp.mapping.scroll_docs(-4),
    -- 				["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- 				["<C-Space>"] = cmp.mapping.complete(),
    -- 				["<C-e>"] = cmp.mapping.close(),
    -- 				["<C-y>"] = cmp.mapping.confirm({ select = true }),
    -- 				["<tab>"] = cmp.mapping.confirm({ select = true }),
    -- 			},
    -- 			-- sources = {
    -- 			--     { name = "path" },
    -- 			--     { name = "nvim_lsp", keyword_length = 3 },
    -- 			--     { name = "buffer",   keyword_length = 5 },
    -- 			-- },
    -- 		})
    -- 		lsp.setup()
    --
    -- 		require("mason-null-ls").setup()
    -- 		local null_ls = require("null-ls")
    -- 		local null_opts = lsp.build_options("null-ls", {})
    -- 		null_ls.setup({
    -- 			on_attach = function(client, bufnr)
    -- 				null_opts.on_attach(client, bufnr)
    -- 			end,
    -- 			diagnostics_format = "[#{c}] #{m} (#{s})",
    -- 			sources = {
    -- 				null_ls.builtins.formatting.stylua,
    -- 				null_ls.builtins.formatting.shfmt,
    -- 				null_ls.builtins.formatting.black,
    -- 				null_ls.builtins.formatting.isort,
    -- 				null_ls.builtins.formatting.prettier,
    -- 				-- null_ls.builtins.diagnostics.yamllint,
    -- 				null_ls.builtins.diagnostics.shellcheck,
    -- 				null_ls.builtins.diagnostics.hadolint,
    -- 			},
    -- 		})
    -- 	end,
    -- 	keys = {
    -- 		{ "<leader>F", "<cmd>:LspZeroFormat<cr>" },
    -- 	},
    -- },
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
                -- popup_border_style = "rounded",
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
            { "-", "<cmd>:Neotree toggle<CR>" },
            { "_", "<cmd>:Neotree toggle reveal<CR>" },
            -- { "<leader>t", "<cmd>:Neotree toggle<CR>" },
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
        opts = { theme = "catppuccin" },
    },
    {
        "Wansmer/treesj",
        -- keys = { "<leader>m", "<leader>j", "<leader>s" },
        keys = { { "gs", "<cmd>:TSJToggle<cr>" } },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesj").setup({})
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            { "<leader>t", "<cmd>:TroubleToggle<cr>" },
        },
    }
    -- {
    --     "akinsho/git-conflict.nvim",
    --     config = function()
    --         require("git-conflict").setup()
    --     end,
    --     keys = {
    --         { "<leader>gc", "<cmd>:GitConflictListQf<cr>" },
    --     },
    -- },
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
vim.opt.wrap = false

-- keymaps
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>lu", "<cmd>:Lazy update<cr>", opts)

vim.api.nvim_set_keymap("n", "cp", [["*y]], opts)
vim.api.nvim_set_keymap("n", "cv", [["*y]], opts)

vim.api.nvim_set_keymap("v", "cp", [["*y]], opts)
vim.api.nvim_set_keymap("v", "cv", [["*y]], opts)

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- trail whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

vim.cmd("colorscheme catppuccin-frappe")
