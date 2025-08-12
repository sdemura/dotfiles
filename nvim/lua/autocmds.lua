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

-- User command to change directory to Git repository root
vim.api.nvim_create_user_command("GitRoot", function()
	local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
	local git_root = ""
	if handle then -- Check if handle is not nil
		git_root = handle:read("*a"):match("^%s*(.-)%s*$")
		handle:close()
	end

	if git_root and git_root ~= "" then
		vim.api.nvim_set_current_dir(git_root)
		vim.notify("Changed directory to " .. git_root, vim.log.levels.INFO)
	else
		vim.notify("Not in a Git repository.", vim.log.levels.WARN)
	end
end, { desc = "Change current directory to Git repository root" })
