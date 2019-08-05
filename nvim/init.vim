let g:python_host_prog=expand('~/.pyenv/versions/neovim-py2/bin/python')
let g:python3_host_prog=expand('~/.pyenv/versions/neovim-py3/bin/python3')

call plug#begin('~/.local/share/nvim/plugged')
" IDE-like things
Plug 'majutsushi/tagbar'
Plug 'sbdchd/neoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'justinmk/vim-dirvish'

" Git Integration
Plug 'airblade/vim-gitgutter'

" Language Specific Plugins
Plug 'sheerun/vim-polyglot'

" UI Enhancements
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'

" Misc
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-eunuch'
Plug 'wellle/targets.vim'
Plug 'milkypostman/vim-togglelist'
call plug#end()


" Settings
" set autochdir
set clipboard+=unnamedplus
set cursorline
set expandtab
set fileformats=unix,dos,mac
set hidden
set history=500
set ignorecase
set inccommand=nosplit
set iskeyword+=$
set langmenu=en
set lazyredraw
set linebreak
set magic

set mouse=a
set nobackup
set noerrorbells
set number
set norelativenumber
set noshowmode
set noswapfile
set novisualbell
set nowrap
set pastetoggle=<F2>
set shiftwidth=4
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=4
set splitbelow
set splitright
set switchbuf=useopen,usetab,newtab
set tabstop=4
set termguicolors
set undofile
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.o,*.pyc
set wildmode=longest,list

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Fast up and/down
map j gj
map k gk

" Color Scheme.
set background=dark
colorscheme onedark

" " Enable Deoplete
" let g:deoplete#enable_at_startup = 1

" " Ale Settings
" let g:ale_sign_column_always = 1

""" NeoVim Terminal mappings
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" vim splits without CTL-W
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Exit terminal insert mode
tnoremap <C-w> <C-\><C-n><Cr>

" Disable line numbers for terminal.
autocmd TermOpen * setlocal nonumber norelativenumber

""" Custom keyboard shorcuts!
:nnoremap <silent> <leader>t :TagbarToggle<Cr>

" Open at last spot in line. from defaults.vim
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Neovim Login Shell
let &shell='/bin/zsh'

" neoformat settings
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_enabled_json = ['jq']
nnoremap <silent> <leader>f :Neoformat<CR>

" lightline settings
let g:lightline = {
        \ 'colorscheme': 'onedark'
        \ }

" strip whitespace on save
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0

" " ale settings
" let g:ale_set_highlights = 0
" let g:ale_echo_msg_format = '%linter%: %s'

" I have a habbit of typing W to save, so we'll remap it.
:command W w

if executable("rg")
    set grepprg=rg\ -i\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" nvr-remote
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

" shortcut to edit nvim config
nnoremap <silent> <leader>nv :e ~/.config/nvim/init.vim<CR>

" https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders
autocmd FileType python let b:coc_root_patterns = ['.git', '.env']

