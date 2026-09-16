vim.api.nvim_create_user_command("PackClean", function()
	local orphans = vim.iter(vim.pack.get(nil, { info = false }))
		:filter(function(plugin) return not plugin.active end)
		:map(function(plugin) return plugin.spec.name end)
		:totable()

	if #orphans == 0 then
		vim.notify("No unused plugins found", vim.log.levels.INFO)
		return
	end

	table.sort(orphans)
	vim.pack.del(orphans)
	vim.notify("Removed: " .. table.concat(orphans, ", "))
end, { desc = "Remove plugins not active in this session" })
