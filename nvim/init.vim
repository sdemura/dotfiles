" Assume we have nvim outright. No need to check this anymore.
let s:editor_root=expand("~/.config/nvim")

" Turn off filetype before loading Vundle.
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#rc(s:editor_root . '/bundle')
call vundle#begin()

" Plugin 'Shougo/deoplete.nvim'
" Plugin 'ervandew/supertab'
" Plugin 'fishbullet/deoplete-ruby'
" Plugin 'sdemura/dracula-vim'
" Plugin 'zchee/deoplete-go'
" Plugin 'zchee/deoplete-jedi'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
" Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'danro/rename.vim'
" Plugin 'davidhalter/jedi-vim'
Plugin 'dracula/vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'fatih/vim-go'
Plugin 'gmarik/Vundle.vim'
Plugin 'hashivim/vim-terraform'
Plugin 'haya14busa/incsearch.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'majutsushi/tagbar'
Plugin 'mhinz/vim-grepper'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'ngmy/vim-rubocop'
" Plugin 'nvie/vim-flake8'
Plugin 'qpkorr/vim-bufkill'
Plugin 'roxma/ncm-rct-complete'
Plugin 'roxma/nvim-completion-manager'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/nerdtree'
" Plugin 'tell-k/vim-autopep8'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-eunuch.git'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/BufOnly.vim'
Plugin 'w0rp/ale'
Plugin 'z0mbix/vim-shfmt'
call vundle#end()

"" Turn filetype on after Vundle
filetype on
filetype indent on
filetype plugin indent on

" Enable syntax highlighting
syntax enable

set mouse=a
set clipboard+=unnamedplus
set history=500
set autoread
set so=7
let $LANG='en'
set langmenu=en

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set ai "Auto indent
set backspace=indent,eol,start
set cmdheight=1
set expandtab
set ffs=unix,dos,mac
set foldcolumn=0
set hid
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set lbr
set magic
set mat=2
set nobackup
set nocursorcolumn      " speed up syntax highlighting
set cursorline
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
set splitbelow
set splitright
set t_vb=
set tabstop=4
set tm=500
set tw=500
set whichwrap+=<,>,h,l
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.o,*.pyc
set wildmenu
set wildmode=longest,list

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if has('persistent_undo')
  set undofile
  set undodir=~/.config/nvim/tmp/undo/
endif

" set guicursor=n-v-c:underline,i-ci-ve:ver25,r-cr:hor20,o:hor50
"     \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
"     \,sm:underline-blinkwait175-blinkoff150-blinkon175

" set guicursor=
" move buffers
" :nmap <Tab> :bnext<CR>
" :nmap <S-Tab> :bprevious<CR>
		:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175
" " Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" Fast up and/down
map j gj
map k gk

" Allow ctrl movements to work with tmux
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

""" Buffer stuff
map <leader>bd :Bclose<cr>:tabclose<cr>gT

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

" Automatically delete trailing spaces on python and coffee files.
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


""" Remember last position in file
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif



" Color Scheme
set background=dark
" colorscheme base16-default-dark
colorscheme dracula

set laststatus=2

" ALE niceness
" always show ALE gutter
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#show_tab_type = 0
let g:airline_powerline_fonts = 0
" let g:airline_theme='tomorrow'
" let g:airline_theme='base16_default'
let g:airline_theme='dracula'
" let g:airline_Theme='solarized'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

""" Python Stuff
let python_highlight_all = 1
autocmd FileType python setlocal cc=79

autocmd Filetype * setlocal formatoptions-=cr
let g:autopep8_disable_show_diff=1

""" NerdTree
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Open NERDTree in the directory of the current file (or /home if no file is open)
" nmap <silent> <C-i> :call NERDTreeToggleInCurDir()<cr>
" try NOT using nerdtree
" let g:loaded_nerd_tree = 1
" let loaded_netrwPlugin = 1
nmap <silent> <leader>o : call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_loc_list_height = 10 
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_python_exec = '/usr/local/bin/python3'
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }


highlight SyntasticErrorSign ctermfg=white ctermbg=red
highlight SyntasticWarningSign ctermfg=white ctermbg=red

""" Auto complete settings
au CompleteDone * pclose
autocmd FileType ruby set completeopt-=preview
autocmd FileType go set completeopt-=preview

autocmd BufWinEnter '__doc__' setlocal bufhidden=delete

""" Autocomplete Tab settings
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
"   \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<CR>"
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
""" IndentGuide Settings
hi IndentGuidesOdd ctermbg=236
hi IndentGuidesEven ctermbg=235
" let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

""" Go Settings
au FileType go nnoremap <leader>g :GoDef<cr>
au FileType go nmap <leader>rt <Plug>(go-run-tab)
au FileType go nmap <Leader>rs <Plug>(go-run-split)
au FileType go nmap <Leader>rv <Plug>(go-run-vertical)

" Open go docs in splits, verticals and tabs.
au FileType go nmap <Leader>gds <Plug>(go-def-split)
au FileType go nmap <Leader>gdv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gdt <Plug>(go-def-tab)

" Return from go doc
au FileType go nmap <Leader>gp :GoDefPop<Cr>
au FileType go nmap <Leader>gd :GoDef<Cr>

" Show a list of interfaces implemented under word:
au FileType go nmap <Leader>s <Plug>(go-implements)

"Show type info for the word under the cursor
au FileType go nmap <Leader>i <Plug>(go-info)

" Rename the indentifier under the cursor
au FileType go nmap <Leader>e <Plug>(go-rename)


let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_fmt_autosave = 1
" let g:go_list_autoclose = 1
" let g:go_list_type = "locationlist"
let g:go_fmt_command = "goimports"
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

""" FileType settings
au BufNewFile,BufRead *.sh set noexpandtab tabstop=2 shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set expandtab
au BufRead,BufNewFile *.html, *.htm, *.php set shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set softtabstop=2
au BufRead,BufNewFile Vagrantfile, *.rb set softtabstop=2
au BufRead,BufNewFile Vagrantfile. *.rb,*.erb set expandtab
au BufRead,BufNewFile Vagrantfile, *.rb,*erb set shiftwidth=2

""" NeoVim Terminal Mode Settings
" always start terminal in insert mode
" autocmd BufWinEnter,WinEnter term://* startinsert
" au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" " Always go back to normal mode when leaving terminal mode
" autocmd BufLeave term://* stopinsert

"Terminal title as status line
:autocmd TermOpen * setlocal statusline=%{b:term_title}

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
" :nnoremap <leader><Esc> :q!<Cr>
:nnoremap <leader>e :e<Space>
:nnoremap <leader>gr :GoRun
:nnoremap <leader>hs :split<Cr>
:nnoremap <leader>ht :split term://$SHELL<Cr>
:nnoremap <leader>n :bnext<Cr>
:nnoremap <leader>p :bprevious<Cr>
:nnoremap <leader>q :q<Cr>
:nnoremap <leader>s :SyntasticToggleMode<cr>
:nnoremap <leader>t :TagbarToggle<CR>
:nnoremap <leader>vs :vsplit<Cr>
:nnoremap <leader>vt :vsplit term://$SHELL<Cr>
:nnoremap <leader>w :w<Cr>
:nnoremap <leader>wq :wq<Cr>

" Enable CTRL+A and CTRL-E in insert mode
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I

""" Custom run stuff
autocmd FileType python nnoremap <buffer> z :w<cr>:exec '!python3' shellescape(@%, 1)<cr>

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

" Deleted text goes into black hole register:
xnoremap p "_dP

" Needed on Linux shells
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  " source ~/.vimrc_background
endif

" Custom theme fixes
" This is for DRACULA theme
" highlight Error term=reverse cterm=bold ctermfg=7 ctermbg=1 guifg=White guibg=Red
hi PmenuSel ctermfg=NONE ctermbg=61 cterm=NONE guifg=NONE guibg=#44475a gui=NONE
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=NONE gui=NONE

" Supposedesly opens editor at last line
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 
