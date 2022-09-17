require("plugins")

--- options
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.lazyredraw = true
vim.opt.linebreak = true
-- vim.opt.list = true
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
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }

vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}]])

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- trail whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

-- keymaps
-- vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>:Neotree toggle<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>:Neotree toggle reveal<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>o", "<cmd>:AerialToggle<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>p", '<cmd>lua require("telescope.builtin").find_files{hidden=true}<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>g", '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>b", '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>s", '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', opts)
vim.api.nvim_set_keymap("n", "s", ":HopWord<CR>", opts)
--
-- place this in one of your configuration file(s)
vim.api.nvim_set_keymap(
    "",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
    ,
    {}
)
vim.api.nvim_set_keymap(
    "",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
    ,
    {}
)
vim.api.nvim_set_keymap(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
)
vim.api.nvim_set_keymap(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
    ,
    {}
)

vim.opt.background = "dark"
vim.g.catppuccin_flavour = "mocha"
vim.cmd("colorscheme catppuccin")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

local navic = require("nvim-navic")
vim.g.navic_silence = true
--
-- vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)

    -- setup aerial
    require("aerial").on_attach(client, bufnr)
    navic.attach(client, bufnr)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
require("lspconfig")["pyright"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
})
require("lspconfig")["gopls"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
})
require("lspconfig")["bashls"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
})
require("lspconfig")["dockerls"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
})
require("lspconfig")["sumneko_lua"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        Lua = {
            version = "LuaJIT",
            diagnostics = {
                globals = { "vim", "describe", "it", "before_each", "after_each", "pending" },
            },
        },
    },
})
require("lspconfig")["yamlls"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
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
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
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
        {
            name = "buffer",
        },
        {
            name = "luasnip",
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

-- Send empty lines to blackhole register
local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end

vim.keymap.set("n", "dd", smart_dd, { noremap = true, expr = true })
vim.cmd("highlight NeoTreeTitleBar guibg=#FFFFFF")
