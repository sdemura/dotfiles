local M = {}

-- LSP Keymaps
local function setup_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }

	-- Navigation
	vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, vim.tbl_extend("force", { desc = "Go to implementation" }, opts))
	vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, vim.tbl_extend("force", { desc = "Go to type definition" }, opts))
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, vim.tbl_extend("force", { desc = "Go to declaration" }, opts))

	-- Information
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", { desc = "Hover" }, opts))
	vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, vim.tbl_extend("force", { desc = "Signature help" }, opts))
	vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, vim.tbl_extend("force", { desc = "Show references" }, opts))

	-- Actions
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", { desc = "Code action" }, opts))
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", { desc = "Rename symbol" }, opts))

	-- Diagnostics
	vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, vim.tbl_extend("force", { desc = "Show line diagnostics" }, opts))
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", { desc = "Go to previous diagnostic" }, opts))
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", { desc = "Go to next diagnostic" }, opts))

	-- Inlay hints
	vim.keymap.set("n", "<leader>lh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, vim.tbl_extend("force", { desc = "Toggle inlay hints" }, opts))

	-- Add LSP definition mapping since it's not in the 0.11.x defaults
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", { desc = "Go to definition" }, opts))
end

-- Diagnostic Configuration
local function setup_diagnostics()
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
end

-- Main LSP Setup
function M.setup()
	setup_diagnostics()

	-- Global LSP configuration (applies to all servers)
	vim.lsp.config("*", {
		on_attach = function(_, bufnr)
			setup_keymaps(bufnr)
		end,
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})

	-- Enable the LSP servers (these will load from lsp/*.lua files)
	vim.lsp.enable({
		"gopls",
		"lua_ls",
		"pyright",
		"ruff",
		"yamlls",
		"jsonls",
		"bashls",
		"helm_ls",
	})
end

return M
