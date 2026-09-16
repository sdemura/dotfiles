local navic = require("nvim-navic")

navic.setup({
	highlight = true,
	separator = " > ",
	depth_limit = 5,
})

local winbar = " %{%v:lua.require'nvim-navic'.get_location()%}"

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
	group = vim.api.nvim_create_augroup("NavicWinbar", { clear = true }),
	callback = function()
		if vim.bo.filetype == "neo-tree" or vim.bo.buftype ~= "" then
			if vim.wo.winbar == winbar then vim.wo.winbar = "" end
			return
		end
		vim.wo.winbar = winbar
	end,
	desc = "Show live breadcrumbs in editing windows",
})
