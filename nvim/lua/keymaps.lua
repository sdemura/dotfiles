-- Editor keymaps (plugin keymaps live in plugin/*.lua)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Leader key" })
vim.keymap.set("n", "<Esc><Esc>", "<cmd>nohlsearch<CR><C-l><CR>", { desc = "Clear search and redraw" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable q" })
vim.keymap.set({ "n", "v", "i" }, "<F1>", "<Nop>", { desc = "Disable F1" })

vim.keymap.set("n", "<leader>u", "<cmd>lua vim.pack.update()<CR>", { desc = "Update plugins" })
-- vim.keymap.set("n", "<leader>pu", "<cmd>lua vim.pack.update(nil, {force = true })<CR>", { desc = "Update plugins" })
vim.keymap.set("n", "<leader>x", "<cmd>PackClean<CR>", { desc = "Clean unused plugins" })

vim.keymap.set("n", "<leader>yf", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied path to clipboard:\n" .. path, vim.log.levels.INFO, { title = "Yank File Path" })
end, { desc = "Yank full file path to clipboard" })

-- Move by visible lines (from mini.basics)
vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })

-- Put empty lines above/below (dot-repeatable)
vim.keymap.set("n", "gO", "<cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Put empty line above" })
vim.keymap.set("n", "go", "<cmd>call append(line('.'),     repeat([''], v:count1))<CR>", { desc = "Put empty line below" })

-- System clipboard
vim.keymap.set({ "n", "x" }, "gy", '"+y', { silent = true, desc = "Copy to system clipboard" })
vim.keymap.set("n", "gp", '"+p', { silent = true, desc = "Paste from system clipboard" })
vim.keymap.set("x", "gp", '"+P', { silent = true, desc = "Paste from system clipboard" })

-- Reselect last changed/put/yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, replace_keycodes = false, desc = "Visually select changed text" })

-- Search inside visual selection
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
