-- Autocommands and User Commands

-- autoformat go and only go as I do not want to use
-- autoformat with conform for all filetypes; just go.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		-- Skip markdown: trailing double-space is a hard line break there.
		if vim.bo.buftype == "" and vim.bo.modifiable and vim.bo.filetype ~= "markdown" then
			require("mini.trailspace").trim()
		end
	end,
	desc = "Trim trailing whitespace",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Highlight yanked text",
})

-- Auto-enter insert mode in terminal
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = vim.schedule_wrap(function(data)
		if vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end),
	desc = "Start terminal in Insert mode",
})

-- Show relative line numbers in linewise/blockwise visual mode
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:[V\x16]*",
	callback = function()
		vim.wo.relativenumber = vim.wo.number
	end,
	desc = "Show relative line numbers in visual",
})
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "[V\x16]*:*",
	callback = function()
		vim.wo.relativenumber = string.find(vim.fn.mode(), "^[V\22]") ~= nil
	end,
	desc = "Hide relative line numbers",
})

-- User command to change directory to Git repository root
vim.api.nvim_create_user_command("GitRoot", function()
	local root = require("util").git_root()
	if root then
		vim.api.nvim_set_current_dir(root)
		vim.notify("Changed directory to " .. root, vim.log.levels.INFO)
	else
		vim.notify("Not in a Git repository.", vim.log.levels.WARN)
	end
end, { desc = "Change current directory to Git repository root" })
