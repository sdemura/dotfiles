local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

--- Keymaps
-- map("n", "<leader>y", '<cmd>lua require("notify")("yanking to system clipboard")<cr> "*y', opts)
-- map("n", "<leader>Y", '<cmd>lua require("notify")("yanking line to system clipboard")<cr> "*Y', opts)
-- map("n", "<leader>p", '"*p <cmd> lua require("notify")("pasted from system clipboard)<cr>', opts)
-- map("n", "<leader>P", '"*P <cmd> lua require("notify")("pasted from system clipboard)<cr>', opts)
--
-- map("v", "<leader>y", '"*y <cmd>lua require("notify")("yanked to system clipboard")<cr>', opts)
-- map("v", "<leader>P", '"*P', opts)
-- map("v", "<leader>p", '"*p', opts)

map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)
map(
    "n",
    "<leader>f",
    '<cmd>lua require("telescope.builtin").find_files{hidden=true}<CR>',
    opts
)
map(
    "n",
    "<leader>g",
    '<cmd>lua require("telescope.builtin").live_grep()<CR>',
    opts
)
map(
    "n",
    "<leader>B",
    '<cmd>lua require("telescope.builtin").buffers()<CR>',
    opts
)
map("n", "<leader>o", ":Neotree toggle<CR>", opts)
map("n", "<leader>b", ":Neotree toggle buffers<CR>", opts)
map("n", "<leader>r", ":Neotree toggle reveal<CR>", opts)
map("n", "<leader>G", ":Neotree toggle git_status<CR>", opts)
map("n", "<leader>s", ":AerialToggle!<CR>", opts)
map("n", "<leader>t", ":TroubleToggle<CR>", opts)
-- map("n", "<leader>s", '<cmd> lua require("telescope.builtin").treesitter()<CR>', opts)
map("n", "<leader>nv", ":e ~/.dotfiles/init.lua<CR>", opts)
map("n", "<leader>i", ":e ~/.dotfiles/lua/plugins.lua<CR>", opts)

map("n", "]t", "gT", opts)
map("n", "[t", "gt", opts)

-- map("t", "<C-w>", [[<C-\><C-N><C-W><CR>]], opts)
map("t", "<esc><esc>", [[<C-\><C-N><CR><C-l><CR>]], opts)

-- place this in one of your configuration file(s)
map(
    "",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    {}
)
vim.api.nvim_set_keymap(
    "",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
    {}
)
map(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>",
    {}
)
map(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>",
    {}
)
map("n", "<sace>h", ":HopWord<cr>", opts)
map("n", "ss", ":HopAnywhere<cr>", opts)

-- make it easier to bounce back and forth between terminals
function _G.set_terminal_keymaps()
    -- local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- https://www.reddit.com/r/neovim/comments/tjvs4z/alt_click_for_multiple_cursors/
map("n", "cg*", 'N"_cgn', opts)

-- bufferline
map("n", "]b", ":BufferLineCycleNext<CR>", opts)
map("n", "[b", ":BufferLineCyclePrev<CR>", opts)
