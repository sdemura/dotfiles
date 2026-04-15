local function get_lock_names()
	local path = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
	local ok, content = pcall(vim.fn.readfile, path)
	if not ok or #content == 0 then return nil end
	local data = vim.json.decode(table.concat(content, "\n"))
	return vim.tbl_keys(data.plugins or data)
end

local function get_declared_names()
	local src = table.concat(vim.fn.readfile(vim.fn.stdpath("config") .. "/lua/plugins.lua"), "\n")
	local names = {}
	for url in src:gmatch('"(https?://[^"]+)"') do
		local name = url:match("([^/]+)$"):gsub("%.git$", "")
		names[name] = true
	end
	for name in src:gmatch('name%s*=%s*"([^"]+)"') do
		names[name] = true
	end
	return names
end

vim.api.nvim_create_user_command("PackClean", function()
	local installed = get_lock_names()
	if not installed then
		vim.notify("No lockfile found", vim.log.levels.WARN)
		return
	end

	local declared = get_declared_names()
	local orphans = vim.tbl_filter(function(name) return not declared[name] end, installed)

	if #orphans == 0 then
		vim.notify("No unused plugins found", vim.log.levels.INFO)
		return
	end

	table.sort(orphans)
	vim.pack.del(orphans)
	vim.notify("Removed: " .. table.concat(orphans, ", "))
end, { desc = "Remove plugins not declared in plugins.lua" })
