require("arborist").setup({
	update_cadence = "weekly",
	ensure_installed = { "go", "lua", "python", "helm", "just" },
})
