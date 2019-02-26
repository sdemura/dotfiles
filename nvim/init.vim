" set python
let s:uname = system('uname -s')
if s:uname ==# "Darwin\n"
    let g:python3_host_prog = '/usr/local/bin/python3'
    let g:python_host_prog = '/usr/local/bin/python'
    let g:LanguageClient_serverCommands = {
        \ 'python': ['/usr/local/bin/pyls', '-v'],
        \ }
else
    let g:python3_host_prog = '/usr/bin/python3'
    let g:python_host_prog = '/usr/bin/python'
    let g:LanguageClient_serverCommands = {
        \ 'python': ['~/.local/bin/pyls', '-v'],
        \ }
endif

" Load Plugins
call plug#begin('~/.local/share/nvim/plugged')
" IDE-like things
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'
Plug 'sbdchd/neoformat'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'scrooloose/nerdtree'

" Git Integration
Plug 'airblade/vim-gitgutter'

" Language Specific Plugins
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'ekalinin/Dockerfile.vim'
Plug 'hashivim/vim-terraform'
Plug 'pearofducks/ansible-vim'
Plug 'saltstack/salt-vim'

"Fuzzy Finding and Search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"
" UI Enhancements
Plug 'christoomey/vim-tmux-navigator'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ap/vim-buftabline'
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'dhruvasagar/vim-zoom'
Plug 'ntpeters/vim-better-whitespace'

" Misc
Plug 'mattn/emmet-vim'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'wellle/targets.vim'
Plug 'milkypostman/vim-togglelist'
Plug 'edkolev/tmuxline.vim'
call plug#end()


" Settings
set autochdir
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
set background=light
colorscheme PaperColor

" Enable Deoplete
let g:deoplete#enable_at_startup = 1

" Ale Settings
let g:ale_sign_column_always = 1

""" NeoVim Terminal mappings
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Exit terminal insert mode
tnoremap <C-w> <C-\><C-n><Cr>

" Disable line numbers for terminal.
autocmd TermOpen * setlocal nonumber norelativenumber

""" Custom keyboard shorcuts!
:nnoremap <silent> <leader>t :TagbarToggle<Cr>

" Open at last spot in line.
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" YAML settings
augroup yaml_settings
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" Neovim Login Shell
let &shell='/bin/bash'

" disable inline errors
let g:LanguageClient_useVirtualText = 0

" Bind <leader>y to forward last-yanked text to Clipper
" -N needed on ubuntu netcat
nnoremap <leader>y :call system('nc -N localhost 8377', @0)<CR>

" vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed = 1

" disable ALE for python so we can use PYLS and deoplete
let g:ale_linters = {'python': [], 'python3': [], 'python2': []}

" prevent deoplete from loading preview windows
set completeopt-=preview

" neoformat settings
let g:neoformat_enabled_python = ['black', 'isort']
let g:neoformat_enabled_json = ['jq']
nnoremap <silent> <leader>n :Neoformat<CR>

" buftabline
let g:buftabline_separators = 1
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

" lightline
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \  },
      \ }

" tmuxline
let g:tmuxline_powerline_separators = 1

" nerd tree toggle
map <silent> <leader>o :NERDTreeToggle<CR>

"LanguageClient context menu
nnoremap <silent><leader>k :call LanguageClient_contextMenu()<CR>

" vim-zoom mapping
nmap <silent> <leader>z <Plug>(zoom-toggle)

" vim-emmett
let g:user_emmet_leader_key=','

" disable snippet support
" until https://github.com/palantir/python-language-server/pull/499/files
let g:LanguageClient_settingsPath = '~/.dotfiles/nvim/settings.json'
let g:LanguageClient_hasSnippetsSupport = 0

" FZF Crap
" hack
" let $FZF_PREVIEW_COMMAND='bat {}'
" command! -bang -nargs=* History call fzf#vim#history(fzf#vim#with_preview({'options': '--no-sort'}))
let $FZF_DEFAULT_OPTS="--cycle --bind 'ctrl-j:ignore,ctrl-k:ignore' --ansi"
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>F :GFiles<CR>
nnoremap <silent> <leader>m :History<CR>
nnoremap <silent> <leader>g :Rg<CR>
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

augroup disable_fzf_statusline
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  \| autocmd FocusGained,BufEnter,BufWinEnter,WinEnter * if &buftype == 'terminal' | silent! normal i | endif
augroup END

" languageclient-neovim
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
let g:LanguageClient_selectionUI = 'location-list'
let g:LanguageClient_fzfContextMenu = 0

" strip whitespace on save
let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm = 0
