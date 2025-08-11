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
						["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.29.12-standalone-strict/_definitions.json"] = "**/templates/**",
					},
				},
			},
		},
	},
}
