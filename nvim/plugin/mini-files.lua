local MiniFiles = require("mini.files")
local ignored = { ".git", ".jj", ".venv", ".ruff_cache", ".mypy_cache" }

MiniFiles.setup({
	windows = { preview = false, width_focus = 50, width_nofocus = 50 },
	mappings = { go_in = "l", go_in_plus = "<CR>" },
	content = {
		filter = function(entry)
			return not vim.tbl_contains(ignored, entry.name)
		end,
	},
})

-- Make `l` only enter directories, not open files
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		vim.keymap.set("n", "l", function()
			local entry = MiniFiles.get_fs_entry()
			if entry and entry.fs_type == "directory" then
				MiniFiles.go_in()
			end
		end, { buffer = args.data.buf_id, desc = "Enter directory only" })

		vim.keymap.set("n", "<BS>", function()
			MiniFiles.go_out()
		end, { buffer = args.data.buf_id, desc = "Go out (backspace)" })
	end,
})

vim.keymap.set("n", "-", function()
	if MiniFiles.close() then return end
	MiniFiles.open(vim.api.nvim_buf_get_name(0))
	-- MiniFiles.go_out()
	-- MiniFiles.go_in()
end, { desc = "Toggle file browser at current file" })

vim.keymap.set("n", "_", function()
	if MiniFiles.close() then return end
	local root = vim.fs.root(0, ".git")
	MiniFiles.open(root)
end, { desc = "Toggle file browser at git root" })
