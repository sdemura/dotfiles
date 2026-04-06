# Migrate from lazy.nvim to vim.pack

## Summary

Replace lazy.nvim with Neovim 0.12's built-in `vim.pack` module. The migration
is minimal-surgery: swap the package manager plumbing while preserving the
existing config structure and all setup modules unchanged.

## Context

- Neovim 0.12 ships `vim.pack`, a built-in plugin manager
- Current config uses lazy.nvim but none of its advanced features (lazy loading,
  `opts`, `config` functions, keybinding-triggered loading)
- Plugin setup is already done via explicit `require('plugin').setup()` calls in
  `plugin-setup.lua`, `completion.lua`, and `lsp-setup.lua` -- this is exactly
  the pattern `vim.pack` expects
- LSP config already uses the modern `vim.lsp.config`/`vim.lsp.enable` pattern

## Approach

Single `vim.pack.add()` call (Approach A from brainstorming). Minimal file
changes, preserves separation of concerns.

## Changes

### 1. `init.lua` -- rewrite middle section

Remove the lazy.nvim bootstrap block (clone + rtp:prepend) and the
`require("lazy").setup(...)` call. Replace with:

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

Key: `require("pack-hooks")` must come before `require("plugins")` so that
`PackChanged` autocommands are registered before `vim.pack.add()` fires.

### 2. `lua/plugins.lua` -- rewrite to vim.pack format

Replace the lazy.nvim spec table with a `vim.pack.add()` call. Full GitHub URLs
required. Dependencies are flattened (no nesting).

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

Translation rules applied:
- `dependencies` flattened to top-level entries
- `version = "*"` becomes `version = vim.version.range("*")` (latest semver tag)
- `branch = "v3.x"` becomes `version = vim.version.range("3.x")`
- `name = "catppuccin"` preserved (repo is `catppuccin/nvim`)
- `name = "barbecue"` dropped (vim.pack uses repo name; `require("barbecue")`
  still works since that's the Lua module name)
- Lazy-only fields (`ft`, `cmd`, `event`, `build`, `priority`) dropped

### 3. `lua/pack-hooks.lua` -- new file

Replaces lazy's `build = ":TSUpdate"`:

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

### 4. Cleanup

- **Delete from repo:** `lazy-lock.json` (git rm)
- **Delete on disk after verifying migration works:** `~/.local/share/nvim/lazy/`
  directory (lazy.nvim itself and all plugins it installed). Do NOT delete this
  before confirming vim.pack works -- it's your rollback safety net.
- **Track in git:** `nvim-pack-lock.json` (auto-generated by vim.pack on first
  run, replaces lazy-lock.json)

### 5. Files unchanged

- `lua/plugin-setup.lua` -- all `setup_*()` functions work as-is
- `lua/completion.lua` -- nvim-cmp setup unchanged
- `lua/lsp-setup.lua` -- already uses vim.lsp.config/enable pattern
- `lua/options.lua`
- `lua/keymaps.lua`
- `lua/autocmds.lua`
- `lsp/*.lua` -- per-server configs unchanged
- `.luarc.json`

## Plugin management commands (post-migration)

- **Update all:** `:lua vim.pack.update()`
- **Update one:** `:lua vim.pack.update({ 'nvim-treesitter' })`
- **Delete:** `:lua vim.pack.del({ 'plugin-name' })` (also remove from config)
- **Help:** `:h vim.pack`

## Risk / rollback

Low risk. If something breaks, reverting the 3 changed files and restoring
`lazy-lock.json` from git returns to the working lazy.nvim setup. The lazy.nvim
installation in `~/.local/share/nvim/lazy/` should be deleted only after
confirming the migration works.
