local g = vim.g
local set = vim.opt

-- Theme settings
g.everforest_background = 'soft'
g.everforest_show_eob = 0
-- g.everforest_ui_contrast = "high"
set.background = 'dark'
vim.cmd('colorscheme nightfox')
-- vim.cmd("colorscheme everforest")

-- Github Dark Theme
-- require('github-theme').setup({theme_style = 'light', hide_inactive_statusline = false}) -- tab pages line, active tab page label
