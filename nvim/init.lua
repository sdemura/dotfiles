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
        "phaazon/hop.nvim",
        config = function()
            require("hop").setup()
        end,
        keys = {
            { "S", "<cmd>:HopWord<CR>" },
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
        "romainchapou/nostalgic-term.nvim",
        config = function()
            require("nostalgic-term").setup({
                mappings = {
                    { "<c-w>h", "h" },
                    { "<c-w>j", "j" },
                    { "<c-w>k", "k" },
                    { "<c-w>l", "l" },
                },
                add_normal_mode_mappings = true,
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    globalstatus = false,
                    section_separators = "",
                    component_separators = "",
                    disabled_filetypes = { statusline = { "neo-tree" }, winbar = { "neo-tree" } },
                    -- ignore_focus = { "neo-tree" },
                },
                sections = {
                    lualine_c = { { "filename", file_status = true, path = 1 } },
                },
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
                    mini = false,
                    neotree = true,
                    mason = true,
                    treesitter = true,
                    hop = true,
                },
            })
            vim.cmd("colorscheme catppuccin")
        end,
    },
    { "RRethy/vim-illuminate" },
    {
        "echasnovski/mini.nvim",
        config = function()
            require("mini.comment").setup({})
            require("mini.ai").setup({})
            require("mini.surround").setup({})
        end,
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
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
            })
        end,
        keys = {
            { "<leader>f", "<cmd>:FzfLua files<CR>" },
            { "<leader>g", "<cmd>:FzfLua live_grep<CR>" },
            { "<leader>s", "<cmd>:FzfLua lsp_document_symbols<CR>" },
            { "<leader>c", "<cmd>:FzfLua files cwd=~/.config<CR>" },
            { "<leader>e", "<cmd>:FzfLua files cwd=~/src/gitlab.com/corelight/engineering/elysium/<CR>" },
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
        lazy = false,
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "jose-elias-alvarez/null-ls.nvim" },
            { "jayp0521/mason-null-ls.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            -- Snippet Collection (Optional)
            { "rafamadriz/friendly-snippets" },
        },
        config = function()
            local lsp = require("lsp-zero")
            lsp.preset("recommended")

            local cmp = require("cmp")
            lsp.setup_nvim_cmp({
                preselect = "none",
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                },
            })
            lsp.setup()

            require("mason-null-ls").setup()
            local null_ls = require("null-ls")
            local null_opts = lsp.build_options("null-ls", {})
            null_ls.setup({
                on_attach = function(client, bufnr)
                    null_opts.on_attach(client, bufnr)
                end,
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
        keys = {
            { "<leader>F", "<cmd>:LspZeroFormat<cr>" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true, use_languagetree = true },
                indent = { enable = true, disable = { "python" } },
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
        config = function()
            require("neo-tree").setup({
                -- popup_border_style = "rounded",
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
        keys = {
            { "-", "<cmd>:Neotree toggle<CR>" },
            { "_", "<cmd>:Neotree toggle reveal<CR>" },
        },
    },
})

--- options
vim.opt.cmdheight = 0
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.switchbuf = "useopen"
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }
vim.opt.wrap = false

-- keymaps
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>lu", "<cmd>:Lazy update<cr>", opts)

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- trail whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })
