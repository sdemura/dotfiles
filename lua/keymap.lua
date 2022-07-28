local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- map("n", "j", "jzz", opts)
-- map("n", "k", "kzz", opts)
-- map("n", "G", "Gzz", opts)

-- Send empty lines to blackhole register
local function smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end

vim.keymap.set("n", "dd", smart_dd, { noremap = true, expr = true })

map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR><C-l><CR>", opts)
map("n", "<leader>f", '<cmd>lua require("telescope.builtin").find_files{hidden=true}<CR>', opts)
map("n", "<leader>g", '<cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
map("n", "<leader>B", '<cmd>lua require("telescope.builtin").buffers()<CR>', opts)
map("n", "<leader>o", ":Neotree toggle<CR>", opts)
map("n", "<leader>b", ":Neotree toggle buffers<CR>", opts)
map("n", "<leader>r", ":Neotree reveal<CR>", opts)
map("n", "<leader>G", ":Neotree toggle git_status<CR>", opts)
map("n", "<leader>s", ":AerialToggle!<CR>", opts)
map("n", "<leader>t", ":TroubleToggle<CR>", opts)
-- map("n", "<leader>s", '<cmd> lua require("telescope.builtin").treesitter()<CR>', opts)
map("n", "<leader>ii", ":e ~/.dotfiles/init.lua<CR>", opts)
map("n", "<leader>ip", ":e ~/.dotfiles/lua/plugins.lua<CR>", opts)
map("n", "<leader>io", ":e ~/.dotfiles/lua/options.lua<CR>", opts)
map("n", "<leader>il", ":e ~/.dotfiles/lua/lsp.lua<CR>", opts)
map("n", "<leader>ic", ":e ~/.dotfiles/lua/other.lua<CR>", opts)

map("n", "]t", "gT", opts)
map("n", "[t", "gt", opts)

-- map("t", "<C-w>", [[<C-\><C-N><C-W><CR>]], opts)
map("t", "<esc><esc>", [[<C-\><C-N><CR><C-l><CR>]], opts)

-- place this in one of your configuration file(s)
map(
    "",
    "f",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
    ,
    {}
)
vim.api.nvim_set_keymap(
    "",
    "F",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>"
    ,
    {}
)
map(
    "",
    "t",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>"
    ,
    {}
)
map(
    "",
    "T",
    "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>"
    ,
    {}
)
map("n", "s", ":HopWord<cr>", opts)

-- bufferline
map("n", "]b", ":BufferLineCycleNext<CR>", opts)
map("n", "[b", ":BufferLineCyclePrev<CR>", opts)
