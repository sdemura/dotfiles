require("plugins")

local set = vim.opt
local g = vim.g
local api = vim.api

--  use lua filetype detection
g.did_load_filetypes = 0

-- global statusline
set.laststatus = 2

-- disable providers I don't want
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Global settings
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0
g.fugitive_gitlab_domains = { "https://maestro.corelight.io" }

--- Options
set.cursorline = true
set.completeopt = { "menu", "menuone", "noselect" }
set.expandtab = true
set.fileformats = "unix,dos,mac"
set.hidden = true
set.ignorecase = true
set.inccommand = "nosplit"
set.langmenu = "en"
set.lazyredraw = true
set.linebreak = true
set.list = true
set.listchars:append("trail:.")
set.magic = true
set.mouse = "a"
set.backup = false
set.errorbells = false
set.relativenumber = true
set.visualbell = false
set.wrap = false
set.number = true
set.pastetoggle = "<F2>"
set.shiftwidth = 4
set.signcolumn = "yes"
set.smartcase = true
set.smartindent = true
set.softtabstop = 4
set.splitbelow = true
set.splitright = true
set.switchbuf = "useopen"
set.tabstop = 4
set.termguicolors = true
-- set.timeoutlen = 1500
set.undofile = true
set.wildignore = set.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }

--- autocmmands
vim.cmd([[
autocmd TermOpen * setlocal nonumber norelativenumber

" Open at last spot in line. from defaults.vim
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Make sure we can surround Bash Variables
" augroup bash_word
"     autocmd!
"     autocmd FileType sh setlocal iskeyword+=$
" augroup END

augroup salt_syn
  au BufNewFile,BufRead *.yml.j2 set filetype=sls
augroup END

" Disable line numbers and sign column for terminal
autocmd TermOpen * setlocal nonumber norelativenumber
]])

-- add some extra time for slow formatters
vim.lsp.buf.formatting_sync(nil, 2000)

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

--- custom diagnostics signs for the gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
})

function OrgImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

vim.cmd([[autocmd BufWritePre *.go lua OrgImports(1000) ]])

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}]])

-- trail whitespace on save
api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e" })

require("nvim-web-devicons").setup()
require("which-key").setup({})

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
            n = {
                ["<esc>"] = actions.close
            }
        },
        file_ignore_patterns = { ".git/", ".vscode/", ".pyenv/" }
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) }
    },
    pickers = {
        find_files = {
            find_command = { "fd", ".", "--type", "file", "--hidden", "--strip-cwd-prefix" }
        },
        live_grep = {
            additional_args = function(opts)
                return { "--hidden" }
            end,
            glob_pattern = "!.git"
        }
    }
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("neo-tree").setup({
    popup_border_style = "rounded",
    close_if_last_window = true,
    -- window = {
    --     mappings = {
    --         ["<cr>"] = "open_with_window_picker",
    --     },
    -- },
    filesystem = {
        window = {
            mappings = {
                ["s"] = "none"
            }
        },
        filtered_items = {
            hide_gitignored = false,
            hide_dotfiles = false
        }
    }
})

require("gitsigns").setup()
require("lualine").setup({
    options = {
        theme = "auto",
        section_separators = "",
        component_separators = ""
    },
    extensions = { "aerial", "fugitive", "neo-tree", "quickfix", "quickfix", "toggleterm" },
    sections = {
        lualine_b = { "branch", { "diff" }, { "diagnostics" } },
        lualine_c = { {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        } },
        lualine_x = { "aerial" }
    }
})

require("nvim-treesitter.configs").setup({
    ensure_installed = { "bash", "go", "hcl", "json", "lua", "make", "markdown", "python", "toml", "vim",
        "yaml" },
    highlight = {
        enable = true
    }
})

require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    terminal_mappings = true,
    shade_terminals = true
    -- 	direction = "sp",
})

-- fix cursor hold
vim.g.cursorhold_updatetime = 100

require("nvim-surround").setup({})
require("Comment").setup({})

require("indent_blankline").setup({
    show_current_context = true
})

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
        java = false
    },
    disable_filetype = { "TelescopePrompt" }
})

require("hop").setup({})

require("stabilize").setup({
    nested = "QuickFixCmdPost,DiagnosticChanged *"
})

require("lsp_signature").setup({
    hi_parameter = "IncSearch"
})

require("go").setup({
    run_in_floaterm = true
})

require("dressing").setup({})

require("git-conflict").setup()

require("neoscroll").setup()

require("incline").setup({})
require("scope").setup({})

require('nvim-treesitter.configs').setup {
    textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
}
local cmp = require("cmp")
cmp.setup({
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
            select = true
        }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = { {
        name = "nvim_lsp"
    }, {
        name = "path"
    }, {
        name = "buffer"
    }, {
        name = "luasnip"
    } }
})
--
require("mason").setup()
require("mason-lspconfig").setup()
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {
    noremap = true,
    silent = true
}
vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)

    -- -- aerials.nvim
    local aerial = require("aerial")
    aerial.setup({
        show_guides = true,
        default_direction = "right"
    })
    aerial.on_attach(client, bufnr)
    require("lsp_signature").on_attach({
        handler_opts = {
            border = "none"
        },
        hint_enable = false
    })
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- setup automatic attach for certain lsp's
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities
})
lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities
})
lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities
})
lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities
})
lspconfig.dockerls.setup({
    on_attach = on_attach,
    capabilities = capabilities
})
lspconfig.sumneko_lua.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            version = "LuaJIT",
            diagnostics = {
                globals = { "vim", "describe", "it", "before_each", "after_each", "pending" }
            }
        }
    }
})
lspconfig.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/taskfile.json"] = "Taskfile.yaml"
            }
        }
    }
})


--- null ls
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
        diagnostics_format = "[#{c}] #{m} (#{s})"
    }
})

-- aerial
require("aerial").setup()

-- trouble
require("trouble").setup()

-- keymaps
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- map("n", "j", "jzz", opts)
-- map("n", "k", "kzz", opts)
-- map("n", "G", "Gzz", opts)

-- Send empty lines to blackhole register
local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end

vim.keymap.set("n", "dd", smart_dd, { noremap = true, expr = true })

map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)
map("n", "<leader>f", '<cmd>lua require("telescope.builtin").find_files{hidden=true}<CR>', opts)
map("n", "<leader>g", '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
map("n", "<leader>B", '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
map("n", "<leader>o", ":Neotree toggle<CR>", opts)
map("n", "<leader>b", ":Neotree toggle buffers<CR>", opts)
map("n", "<leader>r", ":Neotree reveal<CR>", opts)
map("n", "<leader>G", ":Neotree toggle git_status<CR>", opts)
map("n", "<leader>s", ":AerialToggle!<CR>", opts)
map("n", "<leader>t", ":TroubleToggle<CR>", opts)
-- map("n", "<leader>s", '<cmd> lua require("telescope.builtin").treesitter()<CR>', opts)
map("n", "<leader>ii", ":e ~/.dotfiles/init.lua<CR>", opts)
map("n", "<leader>ip", ":e ~/.dotfiles/lua/plugins.lua<CR>", opts)
map("n", "<leader>io", ":e ~/.dotfiles/lua/options.lua<CR>", opts)
map("n", "<leader>il", ":e ~/.dotfiles/lua/lsp.lua<CR>", opts)
map("n", "<leader>ic", ":e ~/.dotfiles/lua/other.lua<CR>", opts)

map("n", "]t", "gT", opts)
map("n", "[t", "gt", opts)

-- map("t", "<C-w>", [[<C-\><C-N><C-W><CR>]], opts)
map("t", "<esc><esc>", [[<C-\><C-N><CR><C-l><CR>]], opts)

-- place this in one of your configuration file(s)
map(
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
map(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
)
map(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
    ,
    {}
)
map("n", "s", ":HopWord<cr>", opts)

-- bufferline
map("n", "]b", ":BufferLineCycleNext<CR>", opts)
map("n", "[b", ":BufferLineCyclePrev<CR>", opts)

-- Theme settings
g.everforest_background = "soft"
g.everforest_show_eob = 0
set.background = "dark"
vim.cmd("colorscheme nordfox")

vim.cmd("highlight NeoTreeTitleBar guibg=#FFFFFF")
