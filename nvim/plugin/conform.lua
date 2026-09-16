require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		go = { "goimports", "gofumpt" },
		sh = { "shfmt" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>F", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
		timeout_ms = 1000,
	})
end, { desc = "Format buffer (manual)" })
