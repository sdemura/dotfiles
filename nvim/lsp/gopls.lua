return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	root_markers = { "go.mod", "go.work", ".git" },
	settings = {
		gopls = {
			-- gofumpt keeps gopls's own format/organize-imports code actions
			-- consistent with conform (which owns BufWritePre formatting).
			gofumpt = true,
			staticcheck = true, -- gopls bundles the analyzers; no external binary needed
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				nilness = true,
				shadow = true,
				useany = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			directoryFilters = { "-node_modules", "-vendor" },
		},
	},
}
