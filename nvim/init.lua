---@diagnostic disable: undefined-global, lowercase-global
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap =
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    print("Installing packer. Restart Neovim")
end

-- start packer!
vim.cmd([[packadd packer.nvim]])

-- Reload Neovim whenever you save the plugins.lua file.
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost init.lua source <afile> | PackerSync
    augroup end
]])

-- Only move on if we can require Packer.
local ok, packer = pcall(require, "packer")
if not ok then
    return
end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
    },
})

require("packer").startup(function(use)
    use("lukas-reineke/indent-blankline.nvim")
    use("nvim-treesitter/nvim-treesitter")
    use({ "nvim-treesitter/nvim-treesitter-textobjects", after = { "nvim-treesitter" } })
    use("numToStr/Comment.nvim")
    use("tpope/vim-fugitive")
    use("tpope/vim-unimpaired")
    use("wbthomason/packer.nvim") -- Package manager
    use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use("akinsho/git-conflict.nvim")
    use("jayp0521/mason-null-ls.nvim")
    use("kyazdani42/nvim-web-devicons")
    use("neovim/nvim-lspconfig")
    use("williamboman/mason-lspconfig.nvim")
    use("williamboman/mason.nvim")
    use("jose-elias-alvarez/null-ls.nvim")
    use("karb94/neoscroll.nvim")
    use("nvim-lualine/lualine.nvim")
    use("windwp/nvim-autopairs")
    use({ "akinsho/toggleterm.nvim", tag = "*" })
    use({ "catppuccin/nvim", as = "catppuccin" })
    use({ "hrsh7th/nvim-cmp", requires = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" } })
    use({ "kylechui/nvim-surround", tag = "*" })
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    })
    use({ "phaazon/hop.nvim", branch = "v2" })

    use("ray-x/go.nvim")
    use("folke/which-key.nvim")
    use({
        "ibhagwan/fzf-lua",
        -- optional for icon support
        requires = { "nvim-tree/nvim-web-devicons" },
    })

    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if packer_bootstrap then
    print("==================================")
    print("    Plugins are being installed")
    print("    Wait until Packer completes,")
    print("       then restart nvim")
    print("==================================")
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    command = "source <afile> | PackerCompile",
    group = packer_group,
    pattern = vim.fn.expand("$MYVIMRC"),
})

vim.opt.background = "dark"
vim.g.catppuccin_flavour = "mocha"
vim.cmd("colorscheme catppuccin")
--
--- options
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.lazyredraw = true
vim.opt.linebreak = true
vim.opt.mouse = "a"
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
vim.opt.wrap = false
vim.opt.wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }

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

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local opts = { noremap = true, silent = true }
--

vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)
vim.api.nvim_set_keymap("n", "-", "<cmd>:Neotree toggle<CR>", opts)
vim.api.nvim_set_keymap("n", "_", "<cmd>:Neotree toggle reveal<CR>", opts)

vim.api.nvim_set_keymap("i", "<C-r>", "<cmd>:FzfLua registers<cr>", opts)
vim.api.nvim_set_keymap("n", '""', "<cmd>:FzfLua registers<cr>", opts)
vim.api.nvim_set_keymap("n", "'", "<cmd>:FzfLua marks<cr>", opts)

vim.api.nvim_set_keymap("n", "<leader>b", ":FzfLua buffers<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>f", ":FzfLua files<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>g", ":FzfLua live_grep<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>s", ":FzfLua lsp_document_symbols<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>c", ":FzfLua files cwd=~/.config<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>y", '"*y', opts)
vim.api.nvim_set_keymap("n", "<leader>Y", '"*Y', opts)

vim.api.nvim_set_keymap("n", "<leader>p", '"*p', opts)
vim.api.nvim_set_keymap("n", "<leader>P", '"*P', opts)

vim.api.nvim_set_keymap("v", "<leader>y", '"*y', opts)
vim.api.nvim_set_keymap("v", "<leader>Y", '"*Y', opts)
vim.api.nvim_set_keymap("v", "<leader>p", '"*p', opts)
vim.api.nvim_set_keymap("v", "<leader>P", '"*P', opts)

-- paste with correct indent
-- nmap("p", "]p")
vim.api.nvim_set_keymap("n", "p", "]p", opts)
vim.api.nvim_set_keymap("n", "P", "]P", opts)

-- I never use macros. RIP macros.
vim.api.nvim_set_keymap("", "q", "<Nop>", {})

-- Hop configuration
vim.api.nvim_set_keymap("n", "s", ":HopWord<CR>", opts)

-- place this in one of your configuration file(s)
local hop = require("hop")
local directions = require("hop.hint").HintDirection
hop.setup({
    multi_windows = true,
})
vim.keymap.set("", "f", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("", "F", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("", "t", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
vim.keymap.set("", "T", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })

require("neo-tree").setup({
    popup_border_style = "rounded",
    close_if_last_window = true,
    source_selector = {
        winbar = true,
        statusline = false,
    },
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

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
    fzf_opts = {
        ["--info"] = "default",
    },
})

require("which-key").setup()
require("go").setup()
require("gitsigns").setup()
require("Comment").setup()
require("neoscroll").setup()
require("nvim-surround").setup({})
require("git-conflict").setup()
require("toggleterm").setup({ open_mapping = [[<c-\>]] })
require("nvim-autopairs").setup({ ignored_next_char = "[%w%.]" })
require("indent_blankline").setup({
    show_current_context = true,
})

-- lualine
require("lualine").setup({
    options = {
        globalstatus = false,
        section_separators = "",
        component_separators = "",
        -- component_separators = { right = "|" },
        -- section_separators = { left = "", right = "" },
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
        -- lualine_a = { { "mode", separator = { right = "" } } },
        lualine_c = {
            {
                "filename",
                file_status = true,
                path = 1,
            },
        },
        -- lualine_z = { { "location", separator = { left = "" } } },
    },
})

-- treesitter

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
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            -- TODO: I'm not sure for this one.
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-null-ls").setup()
-- null-ls
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

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    -- nmap("gr", require("fzf-lua").lsp_references)
    nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    nmap("<leader>F", function()
        vim.lsp.buf.format({ async = true })
    end)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_flags = {}

local servers = { "pyright", "gopls", "bashls", "dockerls" }
for _, lsp in ipairs(servers) do
    require("lspconfig")[lsp].setup({
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
    })
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
})

require("lspconfig").yamlls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
        yaml = {
            customTags = {
                "!reference sequence",
            },
        },
    },
})

-- disable virtual_text (inline) diagnostics and use floating window
-- format the message such that it shows source, message and
-- the error code. Show the message with <space>e
vim.diagnostic.config({
    virtual_text = false,
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
})

local cmp = require("cmp")
cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
        -- expand = function(args)
        --     require("luasnip").lsp_expand(args.body)
        -- end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = {
        {
            name = "nvim_lsp",
        },
        {
            name = "path",
        },
    },
})

--- custom diagnostics signs for the gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

--- for some theme? I don't remember
vim.cmd("highlight NeoTreeTitleBar guibg=#FFFFFF")
