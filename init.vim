let g:python_host_prog = expand('~/.pyenv/versions/neovim-py2/bin/python')
let g:python3_host_prog = expand('~/.pyenv/versions/neovim-py3/bin/python3')

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
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'sbdchd/neoformat'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'mhinz/vim-signify'

" UI Enhancements
" Plug 'justinmk/vim-dirvish'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'

" Themes
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

" Usability improvements
Plug 'milkypostman/vim-togglelist'
Plug 'ntpeters/vim-better-whitespace'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'sdemura/dash.vim'
Plug 'mileszs/ack.vim'

" Fuzzy Finding
Plug 'ctrlpvim/ctrlp.vim'

" Python Autocomplete
Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'

" Go Stuff
Plug 'fatih/vim-go'

" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" Settings
set clipboard^=unnamed,unnamedplus
set cursorline
set expandtab
set fileformats=unix,dos,mac
set hidden
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
set novisualbell
set nowrap
set pastetoggle=<F2>
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

" Fast up and/down
" map j gj
" map k gk
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Color Scheme.
set background=dark
colorscheme nord

" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %s'

" Disable line numbers and sign column for terminal
autocmd TermOpen * setlocal nonumber norelativenumber scl="no"

" Mimic Vim8 Terminal escape
:tnoremap <C-w> <C-\><C-n><CR><C-w>

""" Custom keyboard shorcuts!
:nnoremap <silent> <leader>t :TagbarToggle<Cr>

" Open at last spot in line. from defaults.vim
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" neoformat settings
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_enabled_json = ['jq']
nnoremap <silent> <leader>f :Neoformat<CR>

" strip whitespace on save
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0

" shortcut to edit nvim config
nnoremap <silent> <leader>nv :e ~/.dotfiles/init.vim<CR>

" " list folders at top for dirvish
let g:dirvish_mode = ':sort ,^.*[\/],'

" launch dash from leader d
nmap <silent> <leader>D <Plug>DashSearch

" expand paranthesis after (<CR>
let g:delimitMate_expand_cr = 2

" set leader key for :Ack
nnoremap <leader>a :Ack<space>

" disable popup for jedi completions
augroup disable_python_preview
    autocmd!
    autocmd FileType python setlocal completeopt-=preview
augroup END

" Who needs airline now?
command! GitBranch !pwd && git rev-parse --abbrev-ref HEAD
nnoremap <leader>b :GitBranch<cr>

" I have a habbit of typing W to save, so we'll remap it.
:command! W w

if executable('rg')
    set grepprg=rg\ --smart-case\ --vimgrep\ --no-heading
    let g:ackprg = &grepprg
endif

" Use fd for ctrlp.
if executable('fd')
    let g:ctrlp_user_command = 'fd -i -I -H -t f -c never "" %s'
    let g:ctrlp_use_caching = 0
endif

" disable MODE in statusbar
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ ['lineinfo'], ['percent'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

augroup wrap_text_files
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.txt setlocal textwidth=80
augroup END

" nerdtree
map - :NERDTreeToggle<CR>

" Enable deoplete
let g:deoplete#enable_at_startup = 1

" Enable omni completion for vim-go
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" Disable Jedi completions in favor of deoplete
let g:jedi#completions_enabled = 0
