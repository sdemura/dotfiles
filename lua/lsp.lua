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
