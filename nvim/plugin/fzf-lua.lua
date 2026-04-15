require("fzf-lua").setup({
	files = {
		fd_opts = [[--color=never --type f --type l --exclude .git --exclude .jj --exclude .venv --exclude .ruff_cache --exclude .mypy_cache --hidden --no-ignore --follow]],
	},
	winopts = { preview = { layout = "vertical" } },
	fzf_colors = true,
	grep = {
		rg_opts = [[--hidden --column -g '!.venv' -g "!.git" -g "!.jj" -g "!.ruff_cache" -g "!.mypy_cache" --line-number --no-heading --no-ignore-vcs --color=always --smart-case --max-columns=4096]],
	},
	keymap = { fzf = { true, ["ctrl-q"] = "select-all+accept" } },
})

vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua<CR>", { desc = "Open FzfLua default fuzzy finder" })
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>", { desc = "Find files using FzfLua" })
vim.keymap.set("n", "<leader>g", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep across files" })
vim.keymap.set("n", "<leader>G", "<cmd>FzfLua grep_curbuf<CR>", { desc = "Grep in current buffer" })
vim.keymap.set("n", "<leader>s", "<cmd>FzfLua lsp_document_symbols<CR>", { desc = "List LSP document symbols" })
vim.keymap.set("n", "<leader>d", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "List LSP workspace diagnostics" })
vim.keymap.set("n", "<leader>cc", "<cmd>FzfLua files cwd=~/.config<CR>", { desc = "Find files in ~/.config" })
vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<CR>", { desc = "List open buffers" })
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua registers<CR>", { desc = "Show registers" })
vim.keymap.set("n", "<leader>m", "<cmd>FzfLua marks<CR>", { desc = "Show marks" })
vim.keymap.set("i", "<C-r>", "<cmd>FzfLua registers<CR>", { desc = "Show registers (insert mode)" })
