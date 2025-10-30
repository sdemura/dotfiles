local M = {}

-- LSP Keymaps
local function setup_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }

	-- Diagnostics
	vim.keymap.set(
		"n",
		"e",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", { desc = "Show line diagnostics" }, opts)
	)

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
