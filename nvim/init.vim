" Load Plugins
call plug#begin('~/.local/share/nvim/plugged')
" IDE-like things
Plug 'majutsushi/tagbar'
Plug 'roxma/ncm-rct-complete'
Plug 'roxma/nvim-completion-manager'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'

" Git Integration
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Language Specific Plugins
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-vagrant'
Plug 'ngmy/vim-rubocop'
Plug 'pearofducks/ansible-vim'
Plug 'saltstack/salt-vim'
Plug 'z0mbix/vim-shfmt'

"Fuzzy Finding and Search
Plug 'ctrlpvim/ctrlp.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'nixprime/cpsm', { 'do': 'env PY3=ON ./install.sh' }

" UI Enhancements
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Misc
Plug 'jiangmiao/auto-pairs'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tell-k/vim-autopep8'
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
set noshowmode
set noswapfile
set novisualbell
set nowrap 
set number
set pastetoggle=<F2>
set relativenumber
set shiftwidth=4
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

" Blinking cursor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Fast up and/down
map j gj
map k gk

" Color Scheme
set background=dark
colorscheme nord

" Ale Settings
let g:ale_sign_column_always = 1
let g:ale_python_pylint_executable = 'python3'
let g:airline#extensions#ale#enabled = 1

" Airline Settings
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline_powerline_fonts = 0
let g:airline_theme='nord'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

""" NerdTree
" let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Open NERDTree in the directory of the current file (or /home if no file is open)
" nmap <silent> <C-i> :call NERDTreeToggleInCurDir()<cr>
" let g:loaded_nerd_tree = 0 
nmap <silent> <leader>o : call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
    exe ':NERDTreeClose'
  else
    exe ':NERDTreeFind'
  endif
endfunction

" Vim-Go
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = 'goimports'

""" NeoVim Terminal mappings
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Exit terminal insert mode
tnoremap <C-w> <C-\><C-n><Cr>

autocmd TermOpen * startinsert
" autocmd BufWinEnter,WinEnter term://* startinsert
" autocmd BufWinLeave,WinLeave term://* stopinsert

""" CtrlP settings
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_mruf_max=450    " number of recently opened files
let g:ctrlp_max_files=0     " do not limit the number of searchable files
let g:ctrlp_use_caching = 0 
let g:ctrlp_user_command = 'rg %s --files --hidden --color=never --glob ""'
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'

""" Custom keyboard shorcuts!
:nnoremap <leader>w :w<Cr>
:nnoremap <leader>wq :wq<Cr>
:nnoremap <leader>Q :qall!<Cr>
:nnoremap <silent> <leader>t :TagbarToggle<Cr>

" Map Escape to jj
:imap jj <Esc>

" IncSearch settings
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Open at last spot in line.
augroup remember_position_in_file
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

