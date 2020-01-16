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
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'

" UI Enhancements
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/lightline.vim'
Plug 'justinmk/vim-dirvish'

" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'gruvbox-community/gruvbox'

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
Plug 'mhinz/vim-grepper'

" Fuzzy Finding
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

" Go Stuff
Plug 'fatih/vim-go', {'tag': '*'}

" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'davidhalter/jedi-vim'
Plug 'deoplete-plugins/deoplete-jedi'

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
set notermguicolors
set undofile
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.o,*.pyc

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Fast up and/down
" map j gj
" map k gk
" nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
" nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'


" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %s'

" Disable line numbers and sign column for terminal
" autocmd TermOpen * setlocal nonumber norelativenumber scl="no"
autocmd TermOpen * setlocal scl=no

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
" let g:dirvish_mode = ':sort ,^.*[\/],'

" launch dash from leader d
nmap <silent> <leader>D <Plug>DashSearch

" expand paranthesis after (<CR>
let g:delimitMate_expand_cr = 2

" disable popup for jedi completions
augroup disable_python_preview
    autocmd!
    autocmd FileType python setlocal completeopt-=preview
augroup END
"
" disable popup for go completions
augroup disable_go_preview
    autocmd!
    autocmd FileType go setlocal completeopt-=preview
augroup END

" I have a habbit of typing W to save, so we'll remap it.
:command! W w

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \     'active': {
      \       'left': [ [ 'mode', 'paste' ],
      \                 [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \       'right': [ ['lineinfo'], ['percent'] ]
      \     },
      \     'component_function': {
      \       'gitbranch': 'fugitive#head'
      \     },
      \ }

augroup wrap_text_files
    autocmd!
    autocmd BufRead,BufNewFile *.md,*.txt setlocal textwidth=80
augroup END

" Enable deoplete
let g:deoplete#enable_at_startup = 1

" Enable omni completion for vim-go
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" Disable Jedi completions in favor of deoplete
let g:jedi#completions_enabled = 0

" use G instead of G so we can use g for grepper
let g:jedi#goto_assignments_command = "<leader>G"

" Eon'5 who function signatures
let g:jedi#show_call_signatures = 2

let g:go_fmt_fail_silently = 1

" Ctrl-P replacement
nnoremap <C-p> :Clap files<CR>

" make navigating tabs easier
nnoremap H gT
nnoremap L gt

" Grepper
nnoremap <leader>g :Grepper -tool rg<CR>
let g:grepper = { 'next_tool': '<leader>g' }
let g:grepper.rg = { 'grepprg': 'rg --no-heading --vimgrep --smart-case --regexp' }

" Color Scheme.
set background=dark
colorscheme gruvbox
