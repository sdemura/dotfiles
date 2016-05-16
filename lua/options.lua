local set = vim.opt
local g = vim.g

--  use lua filetype detection
g.did_load_filetypes = 0

-- global statusline
-- set.laststatus = 3

-- disable providers I don't want
g.loaded_python_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Global settings
g.strip_whitespace_on_save = 1
g.strip_whitespace_confirm = 0
g.fugitive_gitlab_domains = { 'https://maestro.corelight.io' }

--- Options
set.cursorline = true
set.completeopt = { 'menu', 'menuone', 'noselect' }
set.expandtab = true
set.fileformats = 'unix,dos,mac'
set.hidden = true
set.ignorecase = true
set.inccommand = 'nosplit'
set.langmenu = 'en'
set.lazyredraw = true
set.linebreak = true
set.list = true
-- set.listchars:append("tab:>-")
set.magic = true
set.mouse = 'a'
set.backup = false
set.errorbells = false
set.relativenumber = false
set.visualbell = false
set.wrap = false
set.number = true
set.pastetoggle = '<F2>'
set.shiftwidth = 4
set.signcolumn = 'yes'
set.smartcase = true
set.smartindent = true
set.softtabstop = 4
set.splitbelow = true
set.splitright = true
set.switchbuf = 'useopen'
set.tabstop = 4
set.termguicolors = true
set.timeoutlen = 1500
set.undofile = true
set.wildignore = set.wildignore + { '*/.git/*', '*/.hg/*', '*/.DS_Store', '*.o', '*.pyc' }

--- autocmmands
vim.cmd([[
autocmd TermOpen * setlocal nonumber norelativenumber

" Open at last spot in line. from defaults.vim
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Make sure we can surround Bash Variables
" augroup bash_word
"     autocmd!
"     autocmd FileType sh setlocal iskeyword+=$
" augroup END

augroup salt_syn
  au BufNewFile,BufRead *.yml.j2 set filetype=sls
augroup END

" Disable line numbers and sign column for terminal
autocmd TermOpen * setlocal nonumber norelativenumber
]])

-- add some extra time for slow formatters
vim.lsp.buf.formatting_sync(nil, 2000)

-- disable virtual_text (inline) diagnostics and use floating window
-- format the message such that it shows source, message and
-- the error code. Show the message with <space>e
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    float = {
        border = 'single',
        format = function(diagnostic)
            return string.format(
                '%s (%s) [%s]',
                diagnostic.message,
                diagnostic.source,
                diagnostic.code or diagnostic.user_data.lsp.code
            )
        end,
    },
})

--- custom diagnostics signs for the gutter
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = 'single',
})

function OrgImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, 'UTF-8')
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

vim.cmd([[autocmd BufWritePre *.go lua OrgImports(1000) ]])

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

vim.cmd([[au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500}]])
