set shell=/bin/zsh

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
Plug 'Raimondi/delimitMate'
Plug 'sbdchd/neoformat'
Plug 'dense-analysis/ale'

" Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'

" UI Enhancements
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'junegunn/vim-peekaboo'

" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'gruvbox-community/gruvbox'

" Usability improvements
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'sdemura/dash.vim'
Plug 'mhinz/vim-grepper'
Plug 'machakann/vim-highlightedyank'

" Salt
Plug 'saltstack/salt-vim'
Plug 'Glench/Vim-Jinja2-Syntax'

" Puppet
Plug 'rodjek/vim-puppet'

" Fuzzy Finding
Plug 'ctrlpvim/ctrlp.vim'

" Code Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
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
set novisualbell
set nowrap
set number
set pastetoggle=<F2>
set norelativenumber
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
let g:ale_echo_msg_format = '%linter%: %s'

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
autocmd FileType yaml setlocal breakindent breakindentopt=shift:2,min:40,sbr showbreak=>> wrap

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

" lightline settings
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
      \   'right': [ ['lineinfo'], ['percent'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \ },
      \ }

" make navigating tabs easier
nnoremap H gT
nnoremap L gt

" NERDTreeToggle
nnoremap <silent> - :NERDTreeToggle %:p:h<cr>
let g:NERDTreeShowHidden=1

" Grepper
nnoremap <leader>gg :GrepperRg<space>
let g:grepper = {}
let g:grepper.tools = ['rg']
let g:grepper.rg = { 'grepprg': 'rg --hidden -g "!.git" -g "!venv" -g "!.venv"--no-heading  --vimgrep --smart-case --regexp' }
let g:grepper.simple_prompt = 1

" saltstack
let g:sls_use_jinja_syntax = 1

" change to basedir of open buffer
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
"
" Use fd for ctrlp.
if executable('fd')
    let g:ctrlp_user_command = 'fd --type f --hidden --exclude .git --exclude venv --exclude .venv --color never "" %s'
    let g:ctrlp_use_caching = 0
endif
let g:ctrlp_working_path_mode = 0

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:jedi#completions_enabled = 0
let g:deoplete#sources#jedi#show_docstring = 1

" Disable preview
set completeopt-=preview

" Vim fugitive shortcuts
nnoremap <leader>ga :Git add<space>
nnoremap <leader>gc :Gcommit<space>
nnoremap <leader>gp :Gpush<space>

" Color Scheme.
set background=light
colorscheme gruvbox
