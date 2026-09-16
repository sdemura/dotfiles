return {
	cmd = { "helm_ls", "serve" },
	filetypes = { "helm" },
	root_markers = { "Chart.yaml", "Chart.yml", ".git" },
	settings = {
		["helm-ls"] = {
			yamlls = {
				path = "yaml-language-server",
				config = {
					schemas = {
						kubernetes = "templates/**",
					},
				},
			},
		},
	},
}
