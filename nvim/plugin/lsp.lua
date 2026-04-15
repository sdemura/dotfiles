-- LSP Keymaps (buffer-local, set on attach)
-- Neovim 0.11 built-in defaults (no need to define): K, [d, ]d
local function setup_keymaps(bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "Go to definition")
	map("n", "gr", vim.lsp.buf.references, "Go to references")
	map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
	map("n", "<leader>e", vim.diagnostic.open_float, "Show line diagnostics")
	map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
	map("n", "<leader>lh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, "Toggle inlay hints")
end

-- Diagnostic Configuration
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.HINT] = "󰌶",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

-- Global LSP configuration (applies to all servers)
vim.lsp.config("*", {
	on_attach = function(client, bufnr)
		setup_keymaps(bufnr)
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, bufnr)
		end
	end,
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Enable the LSP servers (these will load from lsp/*.lua files)
vim.lsp.enable({
	"gopls",
	"lua_ls",
	"ruff",
	"yamlls",
	"jsonls",
	"bashls",
	"helm_ls",
	"typescript",
	"just",
	"ty",
})
