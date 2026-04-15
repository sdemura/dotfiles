local navic = require("nvim-navic")

navic.setup({
	highlight = true,
	separator = " > ",
	depth_limit = 5,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		if vim.bo.filetype == "minifiles" or vim.bo.buftype == "nofile" then
			return
		end
		if navic.is_available() and navic.get_location() ~= "" then
			vim.wo.winbar = " " .. navic.get_location()
		else
			vim.wo.winbar = " "
		end
	end,
})
