local M = {}

-- LSP Keymaps
local function setup_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }

	-- Navigation
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", { desc = "Go to definition" }, opts))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", { desc = "Go to references" }, opts))
	vim.keymap.set(
		"n",
		"gi",
		vim.lsp.buf.implementation,
		vim.tbl_extend("force", { desc = "Go to implementation" }, opts)
	)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", { desc = "Go to declaration" }, opts))

	-- Documentation
	vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", { desc = "Hover documentation" }, opts))
	vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", { desc = "Signature help" }, opts))

	-- Diagnostics
	vim.keymap.set(
		"n",
		"e",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", { desc = "Show line diagnostics" }, opts)
	)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", { desc = "Previous diagnostic" }, opts))
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", { desc = "Next diagnostic" }, opts))

	-- Actions
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", { desc = "Rename symbol" }, opts))
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", { desc = "Code action" }, opts))

	-- Inlay hints
	vim.keymap.set("n", "<leader>lh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, vim.tbl_extend("force", { desc = "Toggle inlay hints" }, opts))
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
		"typescript",
		-- "just",
	})
end

return M
