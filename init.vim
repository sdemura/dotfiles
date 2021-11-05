" set shell=/bin/zsh

let g:python3_host_prog = expand('~/.virtualenvs/neovim-py3/bin/python3')

let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_node_provider = 0

" install vim-plug if not already there
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup install_vim_plug
      autocmd!
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

call plug#begin('~/.local/share/nvim/plugged')
" IDE like things
Plug 'dense-analysis/ale'
Plug 'sbdchd/neoformat'

" Syntax STuff
Plug 'sdemura/earthly.vim', { 'branch': 'main' }

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'

" UI Enhancements
Plug 'preservim/tagbar'
" Plug 'hoob3rt/lualine.nvim'
Plug 'nvim-lualine/lualine.nvim'

" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Neovim 0.5 stuff
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rktjmp/lush.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons' "
Plug 'kyazdani42/nvim-tree.lua'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

" Color Schemes
" Plug 'projekt0n/github-nvim-theme'
Plug 'jvirtanen/vim-hcl'
Plug 'saltstack/salt-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'sainnhe/everforest'

" Usability improvements
Plug 'ntpeters/vim-better-whitespace'
Plug 'terrortylor/nvim-comment'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'sdemura/dash.vim'
Plug 'machakann/vim-highlightedyank'
call plug#end()

" Settings
set clipboard^=unnamed
set completeopt=menuone,noselect " needed for nvim-compe
set completeopt-=preview "Disable preview window
set cursorline
set expandtab
set fileformats=unix,dos,mac
set hidden
set ignorecase
set inccommand=nosplit
set langmenu=en
set lazyredraw
set linebreak
set magic
set mouse=a
set nobackup
set noerrorbells
set norelativenumber
set novisualbell
set nowrap
set number
set pastetoggle=<F2>
set shiftwidth=4
set signcolumn=auto
set smartcase
set smartindent
set softtabstop=4
set splitbelow
set splitright
set switchbuf=useopen
set tabstop=4
set termguicolors
set undofile
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.o,*.pyc

nnoremap Y y$

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %code% %s'

let g:ale_linters = {'python': []}

let g:sls_use_jinja_syntax = 1
"
" Disable line numbers and sign column for terminal
autocmd TermOpen * setlocal nonumber norelativenumber scl="no"
" Mimic Vim8 Terminal escape
:tnoremap <C-w> <C-\><C-n><CR><C-l><C-w><Cr>

" Open at last spot in line. from defaults.vim
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Yaml file settings
augroup yaml_settings
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" Make sure we can surround Bash Variables
augroup bash_word
    autocmd!
    autocmd FileType sh setlocal iskeyword+=$
augroup END

" Markdown settings
augroup md_wrap
    autocmd!
    au BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

augroup salt_syn
  au BufNewFile,BufRead *.yml.j2 set filetype=sls
augroup END

" neoformat settings
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_enabled_json = ['jq']
nnoremap <silent> <leader>f :Neoformat<CR>

" tagbar settings
nnoremap <silent> <leader>t :TagbarToggle<CR>

" strip whitespace on save
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0

" shortcut to edit nvim config
nnoremap <silent> <leader>nv :e ~/.dotfiles/init.vim<CR>

" launch dash from leader d
nmap <silent> <leader>D <Plug>DashSearch

" I have a habbit of typing W to save, so we'll remap it.
:command! W w

" make navigating tabs easier
nnoremap H gT
nnoremap L gt

" change to basedir of open buffer
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" gitlab GBrowse
let g:fugitive_gitlab_domains = ['https://maestro.corelight.io']


" " Remap control r to show registers
inoremap <C-r> <cmd> :lua require 'telescope.builtin'.registers()<cr>

" let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' , '.terraform', '.terraform.lock.hcl' ] "empty by default

if executable('rg')
    set grepprg=rg\ -i\ --vimgrep\ --no-heading\ --hidden\ --glob=!.git\ --glob=!.scannerwork\ --smart-case
    set grepformat^=%f:%l:%c:%m
endif

" Grep awesomeness
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
augroup autoquickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost    l* lwindow
augroup END

function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

let g:better_whitespace_filetypes_blacklist=['TelescopePrompt']

" when you enter a (new) buffer
augroup comments
autocmd!
    autocmd BufEnter *.hcl,*.tf :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
    " when you've changed the name of a file opened in a buffer, the file type may have changed
    autocmd BufFilePost *.hcl,*.tf :lua vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
augroup END

nnoremap <silent><leader>o :NvimTreeToggle<CR>
nnoremap <silent><leader>ff :NvimTreeFindFile<CR>

nnoremap <silent> <C-t> :lua require 'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '--glob=!__pycache__', '--glob=!.terraform', '--glob=!.git', '--glob=!.scannerwork', '--smart-case'}, previewer = false })<cr>



lua <<EOF
-- nvim tree
require'nvim-tree'.setup {
    nvim_tree_ignore = { '.git', 'node_modules', '.cache' , '.terraform', '.terraform.lock.hcl' } -- empty by default
    }

 require('lualine').setup{
     options = {theme = 'everforest'},
     extensions = {'fugitive', 'nvim-tree'},
     sections = {
       lualine_a = {'mode'},
       lualine_b = {'branch'},
       lualine_c = {{'filename', file_status = true, path=1}},
       lualine_x = {'encoding', 'fileformat', 'filetype'},
       lualine_y = {'progress'},
       lualine_z = {'location'}
     },
 }

-- Github Dark Theme
-- require('github-theme').setup({theme_style = 'dark', hide_inactive_statusline = false}) -- tab pages line, active tab page label


--- nvim comment
require('nvim_comment').setup()

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "bash", "yaml", "json"},
  highlight = { enable = true },
 }

--- nvim-cmp
require'cmp'.setup{
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    },
}


--- nvmim cmp
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

--- lspconfig
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
--- end lspconfig

--- gitsigns
require('gitsigns').setup()

--- telescope
local actions = require("telescope.actions")

 require('telescope').setup({
     defaults = {
         mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
    extensions = {
       fzf = {
         fuzzy = true,                    -- false will only do exact matching
         override_generic_sorter = false, -- override the generic sorter
         override_file_sorter = true,     -- override the file sorter
         case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                          -- -- the default case_mode is "smart_case"
       },
     },
 })

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
EOF

let g:everforest_background = 'soft'
colorscheme everforest
