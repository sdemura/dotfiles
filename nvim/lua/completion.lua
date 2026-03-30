local M = {}

function M.setup()
	vim.opt.completeopt = "menu,menuone,noselect,popup"

	-- Use built-in completion keymaps:
	-- <C-y> confirms (Neovim default)
	-- <C-n>/<C-p> navigate (Neovim default)
	-- <C-Space> triggers manually
	vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { desc = "Trigger completion" })

	-- <Tab> to confirm selection (like old nvim-cmp setup)
	vim.keymap.set("i", "<Tab>", function()
		if vim.fn.pumvisible() == 1 then
			return "<C-y>"
		else
			return "<Tab>"
		end
	end, { expr = true, desc = "Confirm completion or insert tab" })
end

return M
