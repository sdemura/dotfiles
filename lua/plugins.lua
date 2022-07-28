---@diagnostic disable: undefined-global, lowercase-global
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim",
        install_path })
    print("Installing packer. Restart Neovim")
end

-- start packer
vim.cmd([[packadd packer.nvim]])

-- Reload Neovim whenever you save the plugins.lua file.
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- Only move on if we can require Packer.
local ok, packer = pcall(require, "packer")
if not ok then
    return
end

packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({
                border = "rounded"
            })
        end
    }
})

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use({ "kyazdani42/nvim-web-devicons" })
    use({ "folke/which-key.nvim" })
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-path")

    use({ "L3MON4D3/LuaSnip" })
    use("saadparwaiz1/cmp_luasnip")

    use({ "hrsh7th/nvim-cmp" })

    use("nathom/filetype.nvim")

    use({ "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", { "neovim/nvim-lspconfig" } })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" }

    })

    use("shumphrey/fugitive-gitlab.vim")
    use("tpope/vim-fugitive")
    use("wellle/targets.vim")
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons"

    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make"
    })
    use({ "nvim-telescope/telescope-ui-select.nvim" })
    use({
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } }

    })
    -- use({
    --     "s1n7ax/nvim-window-picker",
    --     tag = "1.*",
    --     config = function()
    --         require("window-picker").setup({
    --             autoselect_one = true,
    --             include_current = false,
    --             selection_chars = "ABCDEFGHIJKLMNOP",
    --             filter_rules = {
    --                 -- filter using buffer options
    --                 bo = {
    --                     -- if the file type is one of following, the window will be ignored
    --                     filetype = {
    --                         "aerial",
    --                         "neo-tree",
    --                         "neo-tree-popup",
    --                         "notify",
    --                         "quickfix",
    --                         "toggleterm",
    --                         "qf",
    --                         "fugitiveblame",
    --                     },
    --
    --                     -- if the buffer type is one of following, the window will be ignored
    --                     buftype = { "terminal", "quickfix" },
    --                 },
    --             },
    --
    --             other_win_hl_color = "#f4a261",
    --             fg_color = "#dfdfe0",
    --         })
    --     end,
    -- })

    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" -- "s1n7ax/nvim-window-picker",
        }

    })
    use({ "lewis6991/gitsigns.nvim" })
    use({
        "nvim-lualine/lualine.nvim",
        requires = {
            "kyazdani42/nvim-web-devicons",
            opt = true
        }

    })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    })

    use({ "akinsho/toggleterm.nvim" })

    use("EdenEast/nightfox.nvim")

    -- use({
    --     "bennypowers/nvim-regexplainer",
    --     requires = {
    --         "nvim-lua/plenary.nvim",
    --         "MunifTanjim/nui.nvim",
    --     },
    --     config = function() require("regexplainer").setup() end,
    -- })

    -- use("mfussenegger/nvim-dap")
    -- use("mfussenegger/nvim-dap-python")

    use({ "antoinemadec/FixCursorHold.nvim" })

    -- use({
    --     "echasnovski/mini.nvim",
    --     branch = "stable",
    --     config = function()
    --         require("mini.trailspace").setup({})
    --         -- require("mini.surround").setup({})
    --     end,
    -- })

    use({ "kylechui/nvim-surround" })

    use({ "numToStr/Comment.nvim" })

    use({ "lukas-reineke/indent-blankline.nvim" })
    -- using packer.nvim
    -- use({
    --     "akinsho/bufferline.nvim",
    --     tag = "v2.*",
    --     requires = "kyazdani42/nvim-web-devicons",
    --     config = function()
    --         require("bufferline").setup({
    --             options = {
    --                 offsets = {
    --                     {
    --                         filetype = "nvimtree",
    --                         text = "Files",
    --                         text_align = "left",
    --                     },
    --                     {
    --                         filetype = "neo-tree",
    --                         text = "Files",
    --                         text_align = "left",
    --                     },
    --                     {
    --                         filetype = "aerial",
    --                         text = "Symbols",
    --                         text_align = "left",
    --                     },
    --                 },
    --                 -- separator_style = "thick",
    --                 -- show_buffer_close_icons = false,
    --                 enforce_regular_tabs = true,
    --             },
    --         })
    --     end,
    -- })
    use({ "windwp/nvim-autopairs" })
    use({ "tiagovla/scope.nvim" })
    -- use({
    --     "rcarriga/nvim-notify",
    --     config = function()
    --         vim.notify = require("notify")
    --     end
    -- })
    use({ "phaazon/hop.nvim", branch = "v2", })
    use({ "luukvbaal/stabilize.nvim" })
    use({ "ray-x/lsp_signature.nvim" })
    use({ "ray-x/go.nvim" })
    use { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' }

    use({ "stevearc/dressing.nvim" })

    use({ "akinsho/git-conflict.nvim" })

    use({ "karb94/neoscroll.nvim" })
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })
    use({ "b0o/incline.nvim" })
    use({ "stevearc/aerial.nvim" })
    use({ "mfussenegger/nvim-dap" })
    use({ "rcarriga/nvim-dap-ui" })
    use({ "theHamsta/nvim-dap-virtual-text" })
    use({"RRethy/nvim-treesitter-textsubjects"})
    use({"VonHeikemen/lsp-zero.nvim"})

    if packer_bootstrap then
        require("packer").sync()
    end
end)
