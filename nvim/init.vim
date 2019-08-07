let g:python_host_prog=expand('~/.pyenv/versions/neovim-py2/bin/python')
let g:python3_host_prog=expand('~/.pyenv/versions/neovim-py3/bin/python3')

call plug#begin('~/.local/share/nvim/plugged')

Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'joshdick/onedark.vim'
Plug 'justinmk/vim-dirvish'
Plug 'majutsushi/tagbar'
Plug 'milkypostman/vim-togglelist'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sbdchd/neoformat'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'wellle/targets.vim'

call plug#end()

" Settings
" set autochdir " doesn't work with dirvish.
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

" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %s'
let g:ale_sign_column_always = 1
" let g:ale_linters = {
" \   'python': [''],
" \}

" vim splits without CTL-W
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

""" NeoVim Terminal mappings
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

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
let g:lightline = {'colorscheme': 'onedark'}

" strip whitespace on save
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0

" I have a habbit of typing W to save, so we'll remap it.
:command W w

" use ripgrep for grep
if executable("rg")
    set grepprg=rg\ --smart-case\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" nvr-remote
if has('nvr')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

" shortcut to edit nvim config
nnoremap <silent> <leader>nv :e ~/.config/nvim/init.vim<CR>

" list folders at top for dirvish
let g:dirvish_mode = ':sort ,^.*[\/],'

" autochdir hack
" augroup auto_ch_dir
"     autocmd!
"     autocmd BufEnter * silent! lcd %:p:h
" augroup END
