local key_opts = { noremap = true, silent = true }

-- Keymaps:
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Leader key" })
vim.keymap.set("n", "<Esc><Esc>", "<cmd>:nohlsearch<CR><C-l><CR>", key_opts) -- Clear search highlighting and redraw screen
vim.keymap.set("n", "<leader>lu", "<cmd>:Lazy update<CR>", { desc = "Update Lazy plugins" })
vim.keymap.set("n", "q", "<Nop>", key_opts) -- Disable the 'q' key
vim.keymap.set({ "n", "v", "i" }, "<F1>", "<Nop>", key_opts) -- Disable the <F1> key (help)
vim.keymap.set("n", "<leader>r", "<cmd>:GitRoot<CR>", { desc = "Change directory to Git root" })

vim.keymap.set("n", "<leader>yf", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied path to clipboard:\n" .. path, vim.log.levels.INFO, { title = "Yank File Path" })
end, { noremap = true, silent = true, desc = "Yank full file path to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>F", function()
	require("conform").format({
		async = true,
		lsp_fallback = true,
		timeout_ms = 1000,
	})
end, { desc = "Format buffer (manual)" })

-- fzf-lua keybinds:
vim.keymap.set("n", "<leader><leader>", "<cmd>:FzfLua<cr>", { desc = "Open FzfLua default fuzzy finder" })
vim.keymap.set("n", "<leader>f", "<cmd>:FzfLua files<CR>", { desc = "Find files using FzfLua" })
vim.keymap.set("n", "<leader>g", "<cmd>:FzfLua live_grep_glob<CR>", { desc = "Live grep across files" })
vim.keymap.set("n", "<leader>G", "<cmd>:FzfLua grep_curbuf<CR>", { desc = "Grep in current buffer" })
vim.keymap.set("n", "<leader>s", "<cmd>:FzfLua lsp_document_symbols<CR>", { desc = "List LSP document symbols" })
vim.keymap.set(
	"n",
	"<leader>d",
	"<cmd>:FzfLua lsp_workspace_diagnostics<CR>",
	{ desc = "List LSP workspace diagnostics" }
)
vim.keymap.set("n", "<leader>cc", "<cmd>:FzfLua files cwd=~/.config<CR>", { desc = "Find files in ~/.config" })
vim.keymap.set("n", "<leader>b", "<cmd>:FzfLua buffers<cr>", { desc = "List open buffers" })
vim.keymap.set("n", "<leader>r", "<cmd>:FzfLua registers<cr>", { desc = "Show registers" })
vim.keymap.set("n", "<leader>m", "<cmd>:FzfLua marks<cr>", { desc = "Show marks" })
vim.keymap.set("i", "<C-r>", "<cmd>:FzfLua registers<cr>", { desc = "Show registers (insert mode)" })

-- outline.nvim keybinds:
vim.keymap.set("n", "<leader>o", "<cmd>:Outline<CR>", { desc = "Open Outline window" })

-- hop.nvim keybinds:
vim.keymap.set("n", "s", "<cmd>:HopWord<CR>", { desc = "Jump to a word using Hop" })

-- neo-tree.nvim keybinds:
vim.keymap.set("n", "-", "<cmd>:Neotree toggle<CR>", { desc = "Toggle Neo-tree file explorer" })
vim.keymap.set("n", "_", "<cmd>:Neotree toggle reveal<CR>", { desc = "Toggle Neo-tree and reveal current file" })

-- Git browse keybind:
vim.keymap.set("n", "<leader>w", "<cmd>:GBrowse<CR>", { desc = "Open current file in webbrowser" })
