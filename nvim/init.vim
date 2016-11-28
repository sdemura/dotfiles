if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
    set nocompatible
endif

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#rc(s:editor_root . '/bundle')
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Glench/Vim-Jinja2-Syntax'
" Plugin 'stephpy/vim-yaml'
Plugin 'Shougo/deoplete.nvim'
Plugin 'Shougo/vimproc.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
Plugin 'jiangmiao/auto-pairs'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'majutsushi/tagbar'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'osyo-manga/vim-monster'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'PProvost/vim-ps1'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-ruby/vim-ruby'
Plugin 'zchee/deoplete-go'
Plugin 'fatih/molokai'
Plugin 'jnurmine/Zenburn'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'sdemura/dracula-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-scripts/BufOnly.vim'
 " Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plugin 'ryanoasis/vim-devicons'
Plugin 'chriskempson/base16-vim'
Plugin 'zchee/deoplete-jedi'
Plugin 'haya14busa/incsearch.vim'
" Plugin 'Yggdroot/indentLine'
call vundle#end()

filetype off                  " required
filetype plugin indent on
filetype plugin on
filetype indent on

set mouse=a
set encoding=utf-8
set clipboard^=unnamed
set clipboard^=unnamedplus
set history=500
set autoread
set so=7
let $LANG='en'
set langmenu=en

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set wildmenu
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*.o,*.pyc
set ruler
set cmdheight=1
set hid
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set foldcolumn=0
set nu
set splitbelow
set splitright
set nofoldenable
set ffs=unix,dos,mac
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set nocursorcolumn      " speed up syntax highlighting
" set nocursorline
set pastetoggle=<F2>
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines

if has('persistent_undo')
  set undofile
  set undodir=~/.config/nvim/tmp/undo/
endif

" " Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

map j gj
map k gk

map <silent> <leader><cr> :noh<cr>

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

""" Buffer stuff
map <leader>bd :Bclose<cr>:tabclose<cr>gT
" map <leader>ba :bufdo bd<cr>
" map <leader>l :bnext<cr>
" map <leader>h :bprevious<cr>
" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove
" map <leader>t<leader> :tabnext
" let g:lasttab = 1
" nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
" au TabLeave * let g:lasttab = tabpagenr()
" map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" map <leader>cd :cd %:p:h<cr>:pwd<cr>

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

" func! DeleteTrailingWS()
"   exe "normal mz"
"   %s/\s\+$//ge
"   exe "normal `z"
" endfunc
" autocmd BufWrite *.py :call DeleteTrailingWS()
" autocmd BufWrite *.coffee :call DeleteTrailingWS()

" inoremap <C-e> <Esc>A
" inoremap <C-a> <Esc>I

" function! CmdLine(str)
"     exe "menu Foo.Bar :" . a:str
"     emenu Foo.Bar
"     unmenu Foo
" endfunction

" function! VisualSelection(direction, extra_filter) range
"     let l:saved_reg = @"
"     execute "normal! vgvy"

"     let l:pattern = escape(@", '\\/.*$^~[]')
"     let l:pattern = substitute(l:pattern, "\n$", "", "")

"     if a:direction == 'b'
"         execute "normal ?" . l:pattern . "^M"
"     elseif a:direction == 'gv'
"         call CmdLine("Ag \"" . l:pattern . "\" " )
"     elseif a:direction == 'replace'
"         call CmdLine("%s" . '/'. l:pattern . '/')
"     elseif a:direction == 'f'
"         execute "normal /" . l:pattern . "^M"
"     endif

"     let @/ = l:pattern
"     let @" = l:saved_reg
" endfunction

" function! HasPaste()
"     if &paste
"         return 'PASTE MODE  '
"     endif
"     return ''
" endfunction

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

""" Remember last position in file
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Color Scheme
set background=dark
" let base16colorspace=256  " Access colors present in 256 colorspace

let g:solarized_termtrans=1
" let g:molokai_original=1
" colorscheme dracula
colorscheme dracula
" colorscheme molokai
" colorscheme "base16-default-dark"
" colorscheme solarized

set showcmd
set noshowmode

""" Airline Stuff
set laststatus=2

" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline_left_sep=' '
" let g:airline_right_sep= ' '
let g:airline#extensions#tabline#show_tab_type = 0


" set colorcolumn=100
hi FoldColumn ctermbg=none
set cursorline
"hi CursorLine ctermbg=241

""" Python Stuff
let python_highlight_all=1

autocmd FileType python setlocal cc=79

autocmd Filetype * setlocal formatoptions-=cr
let g:autopep8_disable_show_diff=1


""" NerdTree and Syntastic and deoplete

let g:NERDTreeQuitOnOpen = 0
" let g:NERDTreeMouseMode=2
let g:NERDTreeMinimalUI=1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = '/usr/local/bin/python3'
let g:syntastic_auto_jump = 1
let g:syntastic_loc_list_height = 5

let g:syntastic_python_checkers=['pyflakes']

let g:syntastic_javascript_checkers = ['jshint']

let g:syntastic_auto_loc_list = 1
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

highlight SyntasticErrorSign ctermfg=white ctermbg=236
highlight SyntasticWarningSign ctermfg=white ctermbg=236

let g:jedi#force_py_version = 3
let g:jedi#show_call_signatures = 0
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }

let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

" let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

""" Auto complete settings
au CompleteDone * pclose
autocmd FileType ruby set completeopt-=preview
autocmd FileType go set completeopt-=preview
let g:deoplete#enable_at_startup = 1
let g:SuperTabDefaultCompletionType = "<c-n>"

""" Autocomplete Tab settings
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=61
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=60

" " hi IndentGuidesOdd ctermbg=236
" " hi IndentGuidesEven ctermbg=236

" let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
" set ts=4 sw=4 et

" imap <C-Return> <CR><CR><C-o>k<Tab>

""" Go Settings
au FileType go nnoremap <leader>g :GoDef<cr>
au FileType go nmap <leader>rt <Plug>(go-run-tab)
au FileType go nmap <Leader>rs <Plug>(go-run-split)
au FileType go nmap <Leader>rv <Plug>(go-run-vertical)

" autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

""" Vim-go settings
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_fields = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1


""" Random Junk
au BufRead,BufNewFile *.rb,*erb set shiftwidth=2
au BufRead,BufNewFile *.rb,*.erb set expandtab
au BufRead,BufNewFile *.rb set softtabstop=2

au BufRead,BufNewFile *.html, *.htm, *.php set shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set expandtab
au BufRead,BufNewFile *.html, *.htm, *.php set softtabstop=2

""" Bash 
autocmd BufNewFile,BufRead *.sh set noexpandtab tabstop=2 shiftwidth=2

""" MISC
" always start terminal in insert mode
autocmd BufWinEnter,WinEnter term://* startinsert

  " ==================== CtrlP ====================
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_switch_buffer = 'et'  " jump to a file if it's open already
let g:ctrlp_mruf_max=450    " number of recently opened files
let g:ctrlp_max_files=0     " do not limit the number of searchable files
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_match_window = 'bottom,order:btt,max:10,results:10'
" let g:ctrlp_buftag_types = {'go' : '--language-force=go --golang-types=ftv'}

" func! MyCtrlPTag()
"   let g:ctrlp_prompt_mappings = {
"         \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
"         \ 'AcceptSelection("t")': ['<c-t>'],
"         \ }
"   CtrlPBufTag
" endfunc
" command! MyCtrlPTag call MyCtrlPTag()

hi MatchParen cterm=bold ctermbg=none
highlight LineNr ctermbg=none
set fillchars+=vert:│

""" Custom keyboard shorcuts!
:nnoremap <leader>vs :vsplit<Cr>
:nnoremap <leader>hs :split<Cr>
:nnoremap <leader>vt :vsplit term://$SHELL<Cr>
:nnoremap <leader>ht :split term://$SHELL<Cr> 
:nnoremap <leader>c :bw!<Cr>
:nnoremap <leader>n :bnext<Cr>
:nnoremap <leader>p :bprevious<Cr>
:nnoremap <leader>] :w<Cr>
:nnoremap <leader>w :w<Cr>
:nnoremap <leader>][ :wq<Cr>
:nnoremap <leader>wq :wq<Cr>
:nnoremap <leader>q :q<Cr>
:nnoremap <leader><Esc> :q!<Cr>
:nnoremap <leader>][p :qall!<Cr>
:nnoremap <leader>t :TagbarToggle<CR>
" :nnoremap <leader>o :NERDTreeToggle %<cr>
" :nnoremap <leader>o :NERDTreeFind<cr>
:nnoremap <leader>s :SyntasticToggleMode<cr>
:nnoremap <leader>e :e<Space>
:nnoremap <leader>gr :GoRun 

inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I



" Open NERDTree in the directory of the current file (or /home if no file is open)
" nmap <silent> <C-i> :call NERDTreeToggleInCurDir()<cr>
nmap <silent> <leader>o : call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction


""" Custom run stuff
autocmd FileType python nnoremap <buffer> z :w<cr>:exec '!python3' shellescape(@%, 1)<cr>

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" :h g:incsearch#auto_nohlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)


