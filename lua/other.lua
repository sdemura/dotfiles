require("nvim-web-devicons").setup()
require("which-key").setup({})

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
            n = {
                ["<esc>"] = actions.close
            }
        },
        file_ignore_patterns = { ".git/", ".vscode/", ".pyenv/" }
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) }
    },
    pickers = {
        find_files = {
            find_command = { "fd", ".", "--type", "file", "--hidden", "--strip-cwd-prefix" }
        },
        live_grep = {
            additional_args = function(opts)
                return { "--hidden" }
            end,
            glob_pattern = "!.git"
        }
    }
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("neo-tree").setup({
    popup_border_style = "rounded",
    close_if_last_window = true,
    -- window = {
    --     mappings = {
    --         ["<cr>"] = "open_with_window_picker",
    --     },
    -- },
    filesystem = {
        window = {
            mappings = {
                ["s"] = "none"
            }
        },
        filtered_items = {
            hide_gitignored = false,
            hide_dotfiles = false
        }
    }
})

require("gitsigns").setup()
require("lualine").setup({
    options = {
        theme = "auto",
        section_separators = "",
        component_separators = ""
    },
    extensions = { "aerial", "fugitive", "neo-tree", "quickfix", "quickfix", "toggleterm" },
    sections = {
        lualine_b = { "branch", { "diff" }, { "diagnostics" } },
        lualine_c = { {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        } },
        lualine_x = { "aerial" }
    }
})

require("nvim-treesitter.configs").setup({
    ensure_installed = { "bash", "go", "hcl", "json", "lua", "make", "markdown", "python", "toml", "vim",
        "yaml" },
    highlight = {
        enable = true
    }
})

require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    terminal_mappings = true,
    shade_terminals = true
    -- 	direction = "sp",
})

-- fix cursor hold
vim.g.cursorhold_updatetime = 100

require("nvim-surround").setup({})
require("Comment").setup({})

require("indent_blankline").setup({
    show_current_context = true
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
require("nvim-autopairs").setup({
    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    enable_check_bracket_line = false,
    check_ts = true,
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false
    },
    disable_filetype = { "TelescopePrompt" }
})

require("hop").setup({})

require("stabilize").setup({
    nested = "QuickFixCmdPost,DiagnosticChanged *"
})

require("lsp_signature").setup({
    hi_parameter = "IncSearch"
})

require("go").setup({
    run_in_floaterm = true
})

require("dressing").setup({})

require("git-conflict").setup()

require("neoscroll").setup()

require("incline").setup({})
require("scope").setup({})

require('nvim-treesitter.configs').setup {
    textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
}
