local g = vim.g
local set = vim.opt

-- Theme settings
g.everforest_background = "soft"
g.everforest_show_eob = 0
set.background = "dark"
vim.cmd("colorscheme nordfox")

-- require("github-theme").setup({
--   theme_style = "light",
--   dark_sidebar = true,
--   sidebars = {"aerial", "terminal"},
-- })

vim.cmd("highlight NeoTreeTitleBar guibg=#FFFFFF")
