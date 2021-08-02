" set shell=/bin/zsh

let g:python3_host_prog = expand('~/.virtualenvs/neovim-py3/bin/python3')

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

" Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'

" UI Enhancements
Plug 'nathanaelkane/vim-indent-guides'
Plug 'preservim/tagbar'
Plug 'hoob3rt/lualine.nvim'

" Neovim 0.5 stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': '0.5-compat'}
Plug 'rktjmp/lush.nvim'
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }
Plug 'romgrk/barbar.nvim'

" Color Schemes
Plug 'npxbr/gruvbox.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'arcticicestudio/nord-vim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Usability improvements
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'sdemura/dash.vim'
Plug 'machakann/vim-highlightedyank'

" Fuzzy Finding
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Code Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'andersevenrud/compe-tmux'

call plug#end()

" Settings
set clipboard^=unnamed
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
set novisualbell
set nowrap
set number
set pastetoggle=<F2>
set norelativenumber
set signcolumn=auto
set shiftwidth=4
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

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %code% %s'

let g:ale_linters = {'python': ['pylint']}

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
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Make sure we can surround Bash Variables
autocmd FileType sh setlocal iskeyword+=$

" Markdown settings
au BufRead,BufNewFile *.md setlocal textwidth=80

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

" expand paranthesis after (<CR>
let g:delimitMate_expand_cr = 2

" I have a habbit of typing W to save, so we'll remap it.
:command! W w

" make navigating tabs easier
nnoremap H gT
nnoremap L gt

" change to basedir of open buffer
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" gitlab GBrowse
let g:fugitive_gitlab_domains = ['https://maestro.corelight.io']

" Disable preview
set completeopt-=preview

" Vim fugitive shortcuts
nnoremap <leader>ga :Git add<space>
nnoremap <leader>gc :G commit<space>
nnoremap <leader>gp :G push<space>

nnoremap <silent> <C-p> :lua require 'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '--glob=!.git', '--glob=!.scannerwork', '--smart-case'} })<cr>
nnoremap <silent> <leader>b :lua require 'telescope.builtin'.buffers()<cr>

" Indent Guide settings
let g:indent_guides_guide_size=1

" Treesitter stuff
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"hcl", "python", "bash", "yaml", "json"},
  highlight = { enable = true },
}
EOF

let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0
nnoremap <silent> <leader>o :NvimTreeToggle<CR>

lua << EOF
    local nvim_lsp = require('lspconfig')
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      --Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      local opts = { noremap=true, silent=true }

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
      buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
      buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
      buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { "pyright", "bashls" }
    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup { on_attach = on_attach }
    end

    -- Compe setup
    require'compe'.setup {
      enabled = true;
      autocomplete = true;
      debug = false;
      min_length = 1;
      preselect = 'enable';
      throttle_time = 80;
      source_timeout = 200;
      incomplete_delay = 400;
      max_abbr_width = 100;
      max_kind_width = 100;
      max_menu_width = 100;
      documentation = true;

      source = {
        path = true;
        buffer = true;
        nvim_lsp = true;
        tmux = true;
      };
    }
EOF

" Themes!
function NordTheme()
    set background=dark
lua <<EOF
    require('lualine').setup{
        options = {theme = 'nord'},
        extensions = {'fugitive', 'nvim-tree'},
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {{'filename', file_status = true, path=1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        }
    }
EOF
    colorscheme nord
endfunction

" Themes!
function GruvBoxTheme()
lua <<EOF
    require('lualine').setup{
        options = {theme = 'gruvbox'},
        extensions = {'fugitive', 'nvim-tree'},
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {{'filename', file_status = true, path=1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        }
    }
EOF
    set background=dark
    colorscheme gruvbox
endfunction

" Themes!
function GithubLightTheme()
lua <<EOF
    require('lualine').setup{
        options = {theme = 'github'},
        extensions = {'fugitive', 'nvim-tree'},
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {{'filename', file_status = true, path=1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        }
    }
require('github-theme').setup({themeStyle = 'light'}) -- tab pages line, active tab page label

EOF
endfunction

function GithubDarkTheme()
lua <<EOF
    require('lualine').setup{
        options = {theme = 'github'},
        extensions = {'fugitive', 'nvim-tree'},
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch'},
          lualine_c = {{'filename', file_status = true, path=1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        }
    }
require('github-theme').setup({themeStyle = 'dark'}) -- tab pages line, active tab page label

EOF
endfunction

" call GithubLightTheme()
call GithubDarkTheme()
" call GruvBoxTheme()

if executable("rg")
    set grepprg=rg\ -i\ --vimgrep\ --no-heading\ --hidden\ --glob=!.git\ --glob=!.scannerwork\ --smart-case
    "set grepformat=%f:%l:%c:%m,%f:%l:%m
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

