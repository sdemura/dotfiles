" SeanRC - custom vimrc by Sean Demura
" Requires
" - vundle (https://github.com/VundleVim/Vundle.vim)
" -- Protip: don't forget to run :PluginInstall to update your plugins
" Recommended font:
" - https://github.com/adobe-fonts/source-code-pro
" --- Protip: 'pip install fonttools'
" --- Protip:  on Mac, install the OTF versions
" --- Protip:  size 10 looks good on Mac
" - Alternate 'powerline-patched' fonts: https://github.com/powerline/fonts
" Special thanks to:
" - https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" - https://github.com/amix/vimrc

if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
    set nocompatible
endif

set mouse=a

set encoding=utf-8

set clipboard=unnamed

filetype off                  " required




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> BEGIN VUNDLE CONFIG
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#rc(s:editor_root . '/bundle')
call vundle#begin()

" Required plugin:
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)

Plugin 'scrooloose/syntastic'
"Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'
"Plugin 'jnurmine/Zenburn'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
"Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'fatih/vim-go'
Plugin 'tpope/vim-commentary'
Plugin 'jiangmiao/auto-pairs'
Plugin 'vim-autopep8'
Plugin 'altercation/vim-colors-solarized'
"Plugin 'joshdick/onedark.vim'
"Plugin 'Shougo/neocomplete.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'Shougo/deoplete.nvim'
Plugin 'davidhalter/jedi-vim'
"Plugin 'gosukiwi/vim-atom-dark'
"Plugin 'tomasr/molokai'
"Plugin 'mhinz/vim-janah'
"Plugin 'scwood/vim-hybrid'
"Plugin 'hdima/python-syntax'
Plugin 'ervandew/supertab'
"Plugin 'vim-ruby/vim-ruby'
Plugin 'osyo-manga/vim-monster'
Plugin 'zchee/deoplete-go'
Plugin 'Shougo/vimproc.vim'
Plugin 't9md/vim-chef'
Plugin 'vim-ruby/vim-ruby'
Plugin 'majutsushi/tagbar'
Plugin 'saltstack/salt-vim'
Plugin 'stephpy/vim-yaml'
Plugin 'Glench/Vim-Jinja2-Syntax'
"Plugin 'klen/python-mode'
call vundle#end()

filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => BEGIN STUFF -- based off github.com/amix/vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> General
"    -> VIM user interface
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line (vim-airline)
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Parenthesis/brackets
"    -> Helper functions
"    -> Syntastic and Deocomplete
"    -> Python stuff
"    -> Colors and Fonts
"    -> Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" let mapleader = "\<Space>"
" let g:mapleader = "\<Space>"

"let mapleader = "\\"
"let g:mapleader = "\\"


" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=indent,eol,start
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Split options
set splitbelow
set splitright

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
"nnoremap <space> za


" Ability to cancel search with escape
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk



" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext


" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

""""""""""""""""""""""""""""""
" => Status Line (vim-airline)
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" add tabs/buffers topline
let g:airline#extensions#tabline#enabled = 1
" vim-airline theme
let g:airline_theme='solarized'
" powerline fonts
let g:airline_powerline_fonts = 1
" Only show the name of the file in buffer/tab line
let g:airline#extensions#tabline#fnamemod = ':t'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" go to end or beginning of line in insert mode, like BASH
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
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

" Make VIM remember position in file after reopen
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic and Deocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = '/usr/local/bin/python3'
" let g:syntastic_enable_signs = 1
" let g:syntastic_enable_balloons = 1
let g:syntastic_auto_jump = 1
let g:syntastic_loc_list_height = 5

" Python
let g:syntastic_python_checkers=['pyflakes']

" Javascript
let g:syntastic_javascript_checkers = ['jshint']

" Go
let g:syntastic_auto_loc_list = 1
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" Syntastic Errors
highlight SyntasticErrorSign ctermfg=white ctermbg=236
highlight SyntasticWarningSign ctermfg=white ctermbg=236

let g:jedi#force_py_version = 3
let g:jedi#show_call_signatures = 0
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }

" enable deocomplete
let g:deoplete#enable_at_startup = 1

" Go Completion
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

" Ruby Completion
"let g:monster#completion#rcodetools#backend = "async_rct_complete"
"let g:deoplete#sources#omni#input_patterns = {"ruby" : '[^. *\t]\.\w*\|\h\w*::'}

" Go Syntastic Fixes
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Go Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim-Go Settings
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

autocmd FileType go nnoremap <leader>g :GoDef<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ruby Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"spaces for indents
au BufRead,BufNewFile *.rb,*erb set shiftwidth=2
au BufRead,BufNewFile *.rb,*.erb set expandtab
au BufRead,BufNewFile *.rb set softtabstop=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => HTML Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"spaces for indents
au BufRead,BufNewFile *.html, *.htm, *.php set shiftwidth=2
au BufRead,BufNewFile *.html, *.htm, *.php set expandtab
au BufRead,BufNewFile *.html, *.htm, *.php set softtabstop=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Number of spaces that a pre-existing tab is equal to.
" au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4

" "spaces for indents
" au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
" au BufRead,BufNewFile *.py,*.pyw set expandtab
" au BufRead,BufNewFile *.py set softtabstop=4

" " Use the below highlight group when displaying bad whitespace is desired.
" highlight BadWhitespace ctermbg=236 guibg=#303030

" " Display tabs at the beginning of a line in Python mode as bad.
" au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" " Make trailing whitespace be flagged as bad.
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" " Wrap text after a certain number of characters
" au BufRead,BufNewFile *.py,*.pyw, set textwidth=80

" " Use UNIX (\n) line endings.
" au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

" Set the default file encoding to UTF-8:
set encoding=utf-8

" Hide .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"disable diff window in autopep8
let g:autopep8_disable_show_diff=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Syntax Highlight Python

let g:solarized_termtrans=1

"colorscheme onedark
colorscheme solarized
set background=dark
hi MatchParen cterm=bold ctermbg=none
set showcmd
set noshowmode

let python_highlight_all=1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" set colorcolumn to 120
set colorcolumn=100

" PEP8 requires 79 columns
autocmd FileType python setlocal cc=79

" Color the column dark grey
"highlight ColorColumn ctermbg=236

" Execute from go with 'z'
autocmd FileType python nnoremap <buffer> z :w<cr>:exec '!python3' shellescape(@%, 1)<cr>
autocmd FileType go nnoremap <buffer> z :w<cr>:GoRun<cr>
autocmd FileType ruby nnoremap <buffer> z :w<cr>:exec '!ruby' shellescape(@%, 1)<cr>

" Turn off auto comments

"autocmd FileType * setlocal formatoptions-=ro
autocmd Filetype * setlocal formatoptions-=cr

" Tabgar Toggle
nmap <leader>t :TagbarToggle<CR>

" NerdTREE open on right side
let g:NERDTreeWinPos = "right"

" Toggle NERDTree
"map <C-n> :NERDTreeToggle<cr>

map <leader>o :NERDTreeToggle<cr> 

" Toggle SyntasticCheck
map <leader>s :SyntasticToggleMode<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocomplete Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" deoplete.nvim recommend
"set completeopt+=noselect

"let g:SuperTabClosePreviewOnPopupClose = 1

au CompleteDone * pclose
autocmd FileType ruby set completeopt-=preview
autocmd FileType go set completeopt-=preview

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" " http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
