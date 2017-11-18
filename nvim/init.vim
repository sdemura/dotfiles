" Assume we have nvim outright. No need to check this anymore.
let s:editor_root=expand("~/.config/nvim")

call plug#begin('~/.local/share/nvim/plugged')
Plug 'gmarik/Vundle.vim'
" Plug 'Shougo/deoplete.nvim'
" Plug 'danro/rename.vim'
" Plug 'davidhalter/jedi-vim'
" Plug 'dracula/vim'
" Plug 'ervandew/supertab'
" Plug 'fishbullet/deoplete-ruby'
" Plug 'mhinz/vim-grepper'
" Plug 'nvie/vim-flake8'
" Plug 'sdemura/dracula-vim'
" Plug 'tell-k/vim-autopep8'
" Plug 'vim-ruby/vim-ruby'
" Plug 'vim-scripts/BufOnly.vim'
" Plug 'zchee/deoplete-go'
" Plug 'zchee/deoplete-jedi'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'arcticicestudio/nord-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'hashivim/vim-vagrant'
Plug 'haya14busa/incsearch.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'jmcantrell/vim-virtualenv'
Plug 'majutsushi/tagbar'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ngmy/vim-rubocop'
Plug 'qpkorr/vim-bufkill'
Plug 'roxma/ncm-rct-complete'
Plug 'roxma/nvim-completion-manager'
Plug 'saltstack/salt-vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'z0mbix/vim-shfmt'
call plug#end()

"" Turn filetype on after Vundle
filetype on
filetype indent on
filetype plugin indent on

" Enable syntax highlighting
syntax enable

let $LANG='en'
set ai "Auto indent
set autoread
set backspace=indent,eol,start
set clipboard+=unnamedplus
set cmdheight=1
set cursorline
set display+=lastline
set expandtab
set ffs=unix,dos,mac
set foldcolumn=0
set hid
set history=500
set hlsearch
set ignorecase
set incsearch
set langmenu=en
set lazyredraw
set lbr
set laststatus=2
set magic
set mat=2
set mouse=a
set nobackup
set nocursorcolumn      " speed up syntax highlighting
set noerrorbells
set nofoldenable
set noshowmode
set noswapfile
set novisualbell
set nowb
set nowrap "No Wrap lines
set nu
set pastetoggle=<F2>
set ruler
set shiftwidth=4
set showcmd
set showmatch
set si "Smart indent
set smartcase
set smarttab
set so=7
set splitbelow
set splitright
set t_vb=
set tabstop=4
set termguicolors
set tm=500
set tw=500
set undodir=~/.config/nvim/tmp/undo/
set undofile
set whichwrap+=<,>,h,l
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.o,*.pyc
set wildmenu
set wildmode=longest,list

:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Fast up and/down
map j gj
map k gk

" Allow ctrl movements to work with tmux
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Color Scheme
set background=dark
let g:nord_comment_brightness = 20 
colorscheme nord

" ALE niceness
" always show ALE gutter
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline_powerline_fonts = 0
let g:airline_theme='nord'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

""" NerdTree
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Open NERDTree in the directory of the current file (or /home if no file is open)
" nmap <silent> <C-i> :call NERDTreeToggleInCurDir()<cr>
" let g:loaded_nerd_tree = 0 
nmap <silent> <leader>o : call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction
"
let g:indent_guides_guide_size = 1

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

""" FileType settings
au BufNewFile,BufRead *.sh set noexpandtab tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.yaml set noexpandtab tabstop=2 shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set expandtab
au BufRead,BufNewFile *.html, *.htm, *.php set shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set softtabstop=2

" """ NeoVim Terminal mappings
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Exit terminal insert mode
tnoremap <C-w> <C-\><C-n><Cr>

""" CtrlP settings
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_mruf_max=450    " number of recently opened files
let g:ctrlp_max_files=0     " do not limit the number of searchable files
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'

""" Custom keyboard shorcuts!
:nnoremap <leader>w :w<Cr>
:nnoremap <leader>wq :wq<Cr>
:nnoremap <leader>Q :qall!<Cr>

" Map Escape to jj
:imap jj <Esc>

""" IncSearch plugin settings.
let g:incsearch#auto_nohlsearch = 1
map #  <Plug>(incsearch-nohl-#)
map *  <Plug>(incsearch-nohl-*)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map N  <Plug>(incsearch-nohl-N)
map g# <Plug>(incsearch-nohl-g#)
map g* <Plug>(incsearch-nohl-g*)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)

" autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 

" " This actually doesn't work on mac
" hi Cursor ctermfg=NONE guifg=NONE 


au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
