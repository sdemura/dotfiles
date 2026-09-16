local M = {}

function M.git_root()
	return vim.fs.root(0, ".git")
end

return M
