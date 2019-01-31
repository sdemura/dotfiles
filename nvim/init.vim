" set python
let s:uname = system("uname -s")
if s:uname == "Darwin\n"
    let g:python3_host_prog = '/usr/local/bin/python3'
    let g:python_host_prog = '/usr/local/bin/python'
    let g:LanguageClient_serverCommands = {
        \ 'python': ['/usr/local/bin/pyls', '-v'],
        \ }
else
    let g:python3_host_prog = '/usr/bin/python3'
    let g:python_host_prog = '/usr/bin/python'
    let g:LanguageClient_serverCommands = {
        \ 'python': ['/home/sean/.local/bin/pyls', '-v'],
        \ }
endif

" Load Plugins
call plug#begin('~/.local/share/nvim/plugged')
" IDE-like things
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'
Plug 'sbdchd/neoformat'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
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
Plug 'ctrlpvim/ctrlp.vim'

" UI Enhancements
Plug 'sdemura/vim-tmux-navigator', { 'branch': 'indicator' }
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ap/vim-buftabline'
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'

" Misc
Plug 'sdemura/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-fugitive'
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
" Nord Brightness has to be set before activating the color scheme
" let g:nord_comment_brightness = 15
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

""" CtrlP settings
" let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ar'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'
let g:ctrlp_user_command = 'fd --no-ignore --follow --exclude .git --hidden --type f --color never "" %s'
let g:ctrlp_use_caching = 0

""" Custom keyboard shorcuts!
:nnoremap <silent> <leader>t :TagbarToggle<Cr>

" Open at last spot in line.
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Sean Auto pairs
let g:AutoPairsOnlyWhitespace = 1

" YAML settings
augroup yaml_settings
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" Neovim Login Shell
let &shell='/bin/bash --rcfile ~/.bashrc'

" Language Client Neovi settings
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <leader>d :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <leader>r :call LanguageClient#textDocument_references()<CR>

" disable inline errors
let g:LanguageClient_useVirtualText = 0

" Bind <leader>y to forward last-yanked text to Clipper
" -N needed on ubuntu netcat
nnoremap <leader>y :call system('nc -N localhost 8377', @0)<CR>

let g:tmux_navigator_disable_when_zoomed = 1

" disable ALE for python so we can use PYLS and deoplete
let g:ale_linters = {'python': []}

" prevent deoplete from loading preview windows
set completeopt-=preview

" neoformat settings
let g:neoformat_enabled_python = ['black', 'isort']
nnoremap <leader>f :Neoformat<CR>

" buftabline
let g:buftabline_numbers = 1
let g:buftabline_indicators = 1

let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \  }
      \ }

let g:tmuxline_powerline_separators = 0

" nerd tree toggle
map <leader>o :NERDTreeToggle<CR>

" Swap words:
" taken from Eclim
" https://github.com/ervandew/eclim

function! SwapWords() " {{{
  " Initially based on http://www.vim.org/tips/tip.php?tip_id=329

  " save the last search pattern
  let save_search = @/

  normal! "_yiw
  let pos = getpos('.')
  keepjumps s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/
  call setpos('.', pos)

  " restore the last search pattern
  let @/ = save_search

  silent! call repeat#set(":call SwapWords()\<cr>", v:count)
endfunction " }}}

command! SwapWords :call SwapWords()
