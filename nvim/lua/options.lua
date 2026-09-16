-- Set global and local leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--- Options ---
vim.opt.breakindent = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.switchbuf = "useopen"
vim.opt.shortmess:append("c")
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.wildignore = vim.opt.wildignore + { "*/.git/*", "*/.hg/*", "*/.DS_Store", "*.o", "*.pyc" }
vim.opt.wrap = false

-- Disable providers (must be 0 — health check uses strict equality)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

