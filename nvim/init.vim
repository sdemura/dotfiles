" Assume we have nvim outright. No need to check this anymore.
let s:editor_root=expand("~/.config/nvim")

" Turn off filetype before loading Vundle.
filetype off                  

set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#rc(s:editor_root . '/bundle')
call vundle#begin()

" Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plugin 'Shougo/vimproc.vim'
" Plugin 'Yggdroot/indentLine'
" Plugin 'davidhalter/jedi-vim'
" Plugin 'fatih/molokai'
" Plugin 'garyburd/go-explorer'
" Plugin 'jnurmine/Zenburn'
" Plugin 'lilydjwg/python-syntax'
" Plugin 'osyo-manga/vim-monster'
" Plugin 'ryanoasis/vim-devicons'
" Plugin 'stephpy/vim-yaml'
" Plugin 'vim-ruby/vim-ruby'
" Plugin 'vim-scripts/ZoomWin'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'PProvost/vim-ps1'
Plugin 'Shougo/deoplete.nvim'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'fatih/vim-go'
Plugin 'fishbullet/deoplete-ruby'
Plugin 'gmarik/Vundle.vim'
Plugin 'haya14busa/incsearch.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'majutsushi/tagbar'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'sdemura/dracula-vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/BufOnly.vim'
Plugin 'zchee/deoplete-go'
Plugin 'zchee/deoplete-jedi'
call vundle#end()

"" Turn filetype on after Vundle
filetype on
filetype indent on
filetype plugin indent on

" Enable syntax highlighting
syntax enable

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

" set cursorline
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
set nocursorline
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

if has('persistent_undo')
  set undofile
  set undodir=~/.config/nvim/tmp/undo/
endif

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

""" Remember last position in file
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Color Scheme
set background=dark
let g:solarized_termtrans=1
"colorscheme solarized
colorscheme base16-tomorrow-night

""" Airline Stuff
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='tomorrow'

""" Python Stuff
let python_highlight_all = 1
autocmd FileType python setlocal cc=79

autocmd Filetype * setlocal formatoptions-=cr
let g:autopep8_disable_show_diff=1


""" NerdTree
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

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

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_loc_list_height = 5
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }
let g:syntastic_python_checkers=['pyflakes']
let g:syntastic_python_python_exec = '/usr/local/bin/python3'

highlight SyntasticErrorSign ctermfg=white ctermbg=236
highlight SyntasticWarningSign ctermfg=white ctermbg=236

""" Auto complete settings
au CompleteDone * pclose
autocmd FileType ruby set completeopt-=preview
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:SuperTabDefaultCompletionType = "<c-n>"

""" Autocomplete Tab settings
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
"   \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=60
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=60


""" IndentGuide Settings
" hi IndentGuidesOdd ctermbg=236
" hi IndentGuidesEven ctermbg=236
" let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

""" Go Settings
au FileType go nnoremap <leader>g :GoDef<cr>
au FileType go nmap <leader>rt <Plug>(go-run-tab)
au FileType go nmap <Leader>rs <Plug>(go-run-split)
au FileType go nmap <Leader>rv <Plug>(go-run-vertical)

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

""" FileType settings
au BufNewFile,BufRead *.sh set noexpandtab tabstop=2 shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set expandtab
au BufRead,BufNewFile *.html, *.htm, *.php set shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set softtabstop=2
au BufRead,BufNewFile *.rb set softtabstop=2
au BufRead,BufNewFile *.rb,*.erb set expandtab
au BufRead,BufNewFile *.rb,*erb set shiftwidth=2

""" NeoVim Terminal Mode Settings
" always start terminal in insert mode
autocmd BufWinEnter,WinEnter term://* startinsert

" Always go back to normal mode when leaving terminal mode
autocmd BufLeave term://* stopinsert

""" NeoVim Terminal mappings
tnoremap <C-h> <C-\><C-n><C-w>h
" Workaround since <C-h> isn't working in neovim right now
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

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
:nnoremap <leader><Esc> :q!<Cr>
:nnoremap <leader>] :w<Cr>
:nnoremap <leader>][ :wq<Cr>
:nnoremap <leader>][p :qall!<Cr>
:nnoremap <leader>c :bw!<Cr>
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

" Zoom / Restore window.
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-Z> :ZoomToggle<CR>

" Custom configurations
" hi MatchParen cterm=bold ctermbg=none
" highlight LineNr ctermbg=none
" set fillchars+=vert:‚îÇ
