local M = {}

-- LSP Keymaps
local function setup_keymaps(bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }

	vim.keymap.set("n", "gi", function()
		vim.notify("Use 'gri' for implementation (Neovim 0.11.x default)", vim.log.levels.INFO)
	end, vim.tbl_extend("force", { desc = "Implementation (use gri in 0.11.x)" }, opts))

	vim.keymap.set("n", "go", function()
		vim.notify("Use 'grt' for type definition (Neovim 0.11.x default)", vim.log.levels.INFO)
	end, vim.tbl_extend("force", { desc = "Type definition (use grt in 0.11.x)" }, opts))

	vim.keymap.set("n", "gr", function()
		vim.notify("Use 'grr' for references (Neovim 0.11.x default)", vim.log.levels.INFO)
	end, vim.tbl_extend("force", { desc = "References (use grr in 0.11.x)" }, opts))

	vim.keymap.set("n", "gs", function()
		vim.notify("Use '<C-S>' in insert mode for signature help (Neovim 0.11.x default)", vim.log.levels.INFO)
	end, vim.tbl_extend("force", { desc = "Signature help (use <C-S> in insert mode)" }, opts))

	vim.keymap.set("n", "<space>rn", function()
		vim.notify("Use 'grn' for rename (Neovim 0.11.x default)", vim.log.levels.INFO)
	end, vim.tbl_extend("force", { desc = "Rename symbol (use grn in 0.11.x)" }, opts))

	vim.keymap.set("n", "<leader>ca", function()
		vim.notify("Use 'gra' for code action (Neovim 0.11.x default)", vim.log.levels.INFO)
	end, vim.tbl_extend("force", { desc = "Code action (use gra in 0.11.x)" }, opts))

	vim.keymap.set(
		"n",
		"<leader>e",
		vim.diagnostic.open_float,
		vim.tbl_extend("force", { desc = "Open floating diagnostic window" }, opts)
	)

	vim.keymap.set("n", "gK", function()
		local current_config = vim.diagnostic.config().virtual_lines
		vim.diagnostic.config({ virtual_lines = not current_config })
	end, vim.tbl_extend("force", { desc = "Toggle diagnostic virtual text" }, opts))

	vim.keymap.set("n", "gH", function()
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
