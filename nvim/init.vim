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

" UI Enhancements
Plug 'justinmk/vim-dirvish'
Plug 'nathanaelkane/vim-indent-guides'

" Themes
Plug 'morhetz/gruvbox'

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

" Fuzzy Finding
Plug 'ctrlpvim/ctrlp.vim'

call plug#end()

" Settings
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
set novisualbell
set nowrap
set pastetoggle=<F2>
set shiftwidth=4
" set signcolumn=yes
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

filetype plugin indent on

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Fast up and/down
" map j gj
" map k gk
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'
"
" Color Scheme.
set background=dark
colorscheme gruvbox

" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %s'
" let g:ale_sign_column_always = 1

" " vim splits without CTL-W
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

" """ NeoVim Terminal mappings
" tnoremap <C-h> <C-\><C-n><C-w>h
" tnoremap <C-j> <C-\><C-n><C-w>j
" tnoremap <C-k> <C-\><C-n><C-w>k
" tnoremap <C-l> <C-\><C-n><C-w>l

" Disable line numbers and sign column for terminal
autocmd TermOpen * setlocal nonumber norelativenumber scl="no"

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

" use ripgrep for grep
if executable('rg')
    set grepprg=rg\ --smart-case\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Use fd for ctrlp.
if executable('fd')
    let g:ctrlp_user_command = 'fd -i -H -t f -c never "" %s'
    let g:ctrlp_use_caching = 0
endif

" shortcut to edit nvim config
nnoremap <silent> <leader>nv :e ~/.config/nvim/init.vim<CR>

" list folders at top for dirvish
let g:dirvish_mode = ':sort ,^.*[\/],'

" launch dash from leader d
nmap <silent> <leader>d <Plug>DashSearch

" Who needs airline now?
command! GitBranch !pwd && git rev-parse --abbrev-ref HEAD
nnoremap <leader>b :GitBranch<cr>

" I have a habbit of typing W to save, so we'll remap it.
:command! W w

" make some tags!
command! MakeTags !ctags -R .

"
  " return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
" endfunction
" function! GitBranch()
"   return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
" endfunction

" function! StatuslineGit()
"   let l:branchname = GitBranch()
"   return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
" endfunction

" set statusline=%{StatuslineGit()}\%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
