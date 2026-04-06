# vim.pack Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace lazy.nvim with Neovim 0.12's built-in `vim.pack` module.

**Architecture:** Single `vim.pack.add()` call in `lua/plugins.lua` lists all plugins as full GitHub URLs. A new `lua/pack-hooks.lua` registers `PackChanged` autocommands for build steps (treesitter). `init.lua` drops the lazy bootstrap and wires up the new modules. All existing setup modules (`plugin-setup.lua`, `completion.lua`, `lsp-setup.lua`) remain unchanged.

**Tech Stack:** Neovim 0.12, `vim.pack`, Lua

**Spec:** `docs/superpowers/specs/2026-03-30-vim-pack-migration-design.md`

---

### Task 1: Create `lua/pack-hooks.lua`

**Files:**
- Create: `lua/pack-hooks.lua`

- [ ] **Step 1: Create the pack-hooks module**

```lua
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})
```

- [ ] **Step 2: Commit**

```
git add lua/pack-hooks.lua
git commit -m "Add pack-hooks for vim.pack PackChanged autocommands"
```

---

### Task 2: Rewrite `lua/plugins.lua` for vim.pack

**Files:**
- Modify: `lua/plugins.lua` (full rewrite)

- [ ] **Step 1: Rewrite plugins.lua**

Replace the entire file with:

```lua
vim.pack.add({
	-- Simple plugins
	"https://github.com/towolf/vim-helm",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/shumphrey/fugitive-gitlab.vim",
	"https://github.com/tpope/vim-rhubarb",
	"https://github.com/tpope/vim-eunuch",
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/hedyhli/outline.nvim",
	"https://github.com/yorickpeterse/nvim-tree-pairs",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/vladdoster/remember.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/smoka7/hop.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/tiagovla/scope.nvim",

	-- Plugins with version pinning
	{ src = "https://github.com/BrunoKrugel/bbq.nvim", version = vim.version.range("*") },
	{ src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3.x") },

	-- Dependencies (listed explicitly, no nesting)
	"https://github.com/SmiteshP/nvim-navic",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/s1n7ax/nvim-window-picker",

	-- Completion stack
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/saadparwaiz1/cmp_luasnip",
	"https://github.com/onsails/lspkind.nvim",

	-- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/RRethy/nvim-treesitter-endwise",

	-- Formatting and UI
	"https://github.com/stevearc/conform.nvim",
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})
```

- [ ] **Step 2: Commit**

```
git add lua/plugins.lua
git commit -m "Rewrite plugins.lua for vim.pack"
```

---

### Task 3: Rewrite `init.lua`

**Files:**
- Modify: `init.lua:6-24` (replace lazy bootstrap with vim.pack wiring)

- [ ] **Step 1: Replace lazy bootstrap with vim.pack requires**

Remove lines 6-24 (the lazy.nvim bootstrap block and `require("lazy").setup(...)` call). Replace with:

```lua
-- Plugin hooks (must be defined before vim.pack.add)
require("pack-hooks")

-- Install and load plugins
require("plugins")
```

The full file should read:

```lua
-- Load core configuration
require("options")
require("keymaps")
require("autocmds")

-- Plugin hooks (must be defined before vim.pack.add)
require("pack-hooks")

-- Install and load plugins
require("plugins")

-- Setup configurations
require("completion").setup()
require("plugin-setup").setup()
require("lsp-setup").setup()

-- Set colorscheme
vim.cmd.colorscheme("catppuccin-macchiato")
```

- [ ] **Step 2: Commit**

```
git add init.lua
git commit -m "Replace lazy.nvim bootstrap with vim.pack"
```

---

### Task 4: Remove lazy-lock.json

**Files:**
- Delete: `lazy-lock.json`

- [ ] **Step 1: Remove lazy-lock.json from repo**

```
git rm lazy-lock.json
```

- [ ] **Step 2: Commit**

```
git commit -m "Remove lazy-lock.json"
```

---

### Task 5: Verify migration

- [ ] **Step 1: Launch Neovim and confirm plugins install**

Open a terminal and run `nvim`. On first launch, `vim.pack` will show a
confirmation dialog listing all plugins to install. Press `a` to allow all.
Wait for installation to complete.

- [ ] **Step 2: Verify plugins loaded**

Run inside Neovim:
- `:checkhealth` -- check for errors in LSP, treesitter, etc.
- `:lua print(vim.inspect(vim.pack.list()))` -- should list all installed plugins
- Open a Go/Lua/Python file and confirm LSP attaches (`:LspInfo` or check for diagnostics)
- Confirm treesitter highlighting works (syntax should be colored)
- Confirm completion works (type and trigger with `<C-Space>`)
- Confirm colorscheme loaded (should be catppuccin-macchiato)
- `:Outline` -- should open outline panel
- `:Neo-tree` -- should open file tree
- `:FzfLua files` -- should open fuzzy finder

- [ ] **Step 3: Confirm lockfile generated**

Check that `nvim-pack-lock.json` exists in the config directory:

```
ls ~/.config/nvim/nvim-pack-lock.json
```

- [ ] **Step 4: Track the new lockfile**

```
git add nvim-pack-lock.json
git commit -m "Add nvim-pack-lock.json"
```

- [ ] **Step 5: Clean up old lazy.nvim data (manual, after verification)**

Only after confirming everything works:

```
rm -rf ~/.local/share/nvim/lazy
```
