require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_organize_imports" },
		go = { "goimports", "gofmt" },
		sh = { "shfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
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
