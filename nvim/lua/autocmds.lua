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
vim.api.nvim_create_autocmd(
	"BufWritePre",
	{ command = ":lua MiniTrailspace.trim()", desc = "Trim trailing whitespace" }
)

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
	local root = vim.fs.root(0, ".git")
	if root then
		vim.api.nvim_set_current_dir(root)
		vim.notify("Changed directory to " .. root, vim.log.levels.INFO)
	else
		vim.notify("Not in a Git repository.", vim.log.levels.WARN)
	end
end, { desc = "Change current directory to Git repository root" })
