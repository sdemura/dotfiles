-- Set global and local leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Options ---
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = "useopen"
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }
vim.opt.wrap = false

-- Disable specific built-in plugins
vim.g.editorconfig = false
vim.g.loaded_man = false
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

