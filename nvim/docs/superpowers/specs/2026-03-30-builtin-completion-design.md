# Migrate from nvim-cmp to built-in LSP completion

## Summary

Replace nvim-cmp and its 6 companion plugins with Neovim 0.12's built-in
`vim.lsp.completion` module. Reduces the plugin count by 7 and simplifies the
completion setup to ~15 lines.

## Context

- Neovim 0.12 ships `vim.lsp.completion.enable()` with `autotrigger` support
  and a new `'autocomplete'` option
- Current config uses nvim-cmp with 4 sources: LSP, LuaSnip, buffer, path
- The only nvim-cmp features actually used are: auto-popup, Tab/C-y to confirm,
  C-Space to trigger, lspkind icons
- User accepts losing path completion and lspkind icons in exchange for simpler
  config

## Changes

### 1. Remove 7 plugins from `lua/plugins.lua`

Remove from the `vim.pack.add()` call:
- `https://github.com/hrsh7th/nvim-cmp`
- `https://github.com/hrsh7th/cmp-nvim-lsp`
- `https://github.com/hrsh7th/cmp-buffer`
- `https://github.com/hrsh7th/cmp-path`
- `https://github.com/L3MON4D3/LuaSnip`
- `https://github.com/saadparwaiz1/cmp_luasnip`
- `https://github.com/onsails/lspkind.nvim`

### 2. Rewrite `lua/completion.lua`

Replace the entire nvim-cmp setup with built-in completion configuration:

```lua
local M = {}

function M.setup()
  vim.opt.completeopt = "menu,menuone,noselect,popup"

  -- Use built-in completion keymaps:
  -- <C-y> confirms (Neovim default)
  -- <C-n>/<C-p> navigate (Neovim default)
  -- <C-Space> triggers manually
  vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { desc = "Trigger completion" })

  -- <Tab> to confirm selection (like old nvim-cmp setup)
  vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
      return "<C-y>"
    else
      return "<Tab>"
    end
  end, { expr = true, desc = "Confirm completion or insert tab" })
end

return M
```

### 3. Update `lua/lsp-setup.lua`

Enable built-in LSP completion in `on_attach` and remove `cmp_nvim_lsp`
capabilities:

```lua
vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        setup_keymaps(bufnr)
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end,
})
```

Changes:
- `on_attach` signature: `(_, bufnr)` becomes `(client, bufnr)` (need client.id)
- Remove `capabilities = require("cmp_nvim_lsp").default_capabilities()`
- Add `vim.lsp.completion.enable()` call with `autotrigger = true`

### 4. Remove `completeopt` from `lua/options.lua`

The `completeopt` setting moves into `completion.lua` where it belongs, with the
new `popup` flag added.

### 5. Delete plugins on disk after verifying

Run inside Neovim after confirming everything works:

```
:lua vim.pack.del({ 'nvim-cmp', 'cmp-nvim-lsp', 'cmp-buffer', 'cmp-path', 'LuaSnip', 'cmp_luasnip', 'lspkind.nvim' })
```

## Files unchanged

- `lua/plugin-setup.lua`
- `lua/keymaps.lua`
- `lua/autocmds.lua`
- `lua/pack-hooks.lua`
- `lsp/*.lua`
- `init.lua`

## Verification

- Open a Go/Lua/Python file, confirm completion auto-triggers on typing
- Confirm `<Tab>` confirms selection, `<C-Space>` triggers manually
- Confirm kind text shows in the menu (e.g., "Function", "Field")
- Confirm `completeopt` includes `popup` (`:set completeopt?`)

## Rollback

Revert the 4 changed files from git. The removed plugins are still on disk
until explicitly deleted with `vim.pack.del()`.
