" set shell=/bin/zsh

let g:python3_host_prog = expand('~/.virtualenvs/neovim-py3/bin/python3')

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
Plug 'sbdchd/neoformat'
Plug 'windwp/nvim-autopairs'

" Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'

" UI Enhancements
Plug 'nathanaelkane/vim-indent-guides'
Plug 'preservim/tagbar'
Plug 'hoob3rt/lualine.nvim'

" Neovim 0.5 stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ChristianChiarulli/nvcode-color-schemes.vim'

Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Themes
Plug 'gruvbox-community/gruvbox'
" Plug 'arcticicestudio/nord-vim'

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

" Fuzzy Finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Settings
" set clipboard^=unnamed,unnamedplus
set clipboard=unnamedplus
set cursorline
set expandtab
set fileformats=unix,dos,mac
set hidden
set ignorecase
set inccommand=nosplit
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
set signcolumn=auto
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

" Use the almighty , for leader, but also keep \
nmap \ ,
let mapleader = ","

" Make double-<Esc> clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" " Ale Settings
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '%linter%: %code% %s'

let g:ale_linters = {'python': ['pylint']}
" let g:ale_linters = ['shellcheck']
" let g:ale_linters_explicit = 1

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
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Make sure we can surround Bash Variables
autocmd FileType sh setlocal iskeyword+=$

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

" make navigating tabs easier
nnoremap H gT
nnoremap L gt

" Grepper
nnoremap <leader>gg :GrepperRg<space>
let g:grepper = {}
let g:grepper.tools = ['rg']
let g:grepper.rg = {'grepprg': 'rg --hidden -g "!.git" -g "!venv" -g "!.venv" --no-heading  --vimgrep --smart-case --regexp'}
let g:grepper.simple_prompt = 1

" change to basedir of open buffer
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:jedi#completions_enabled = 0
let g:deoplete#sources#jedi#show_docstring = 1

" gitlab GBrowse
let g:fugitive_gitlab_domains = ['https://maestro.corelight.io']

" Disable preview
set completeopt-=preview

" Vim fugitive shortcuts
nnoremap <leader>ga :Git add<space>
nnoremap <leader>gc :G commit<space>
nnoremap <leader>gp :G push<space>

nnoremap <leader>b :Buffers<cr>
nnoremap <leader>p :Files<cr>


" Indent Guide settings
let g:indent_guides_guide_size=1

" Treesitter stuff
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "bash", "yaml", "json"},
  highlight = { enable = true },
}
EOF

lua <<EOF
require('nvim-autopairs').setup({
  ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
  check_line_pair = false
})
EOF

" nnoremap <leader>f NvimTreeToggle<cr>
let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0
nnoremap <silent> <leader>o :NvimTreeToggle<CR>

" Coc stuff
"" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Themes!
function NordTheme()
    set background=dark
    let $BAT_THEME='Nord'

    lua <<EOF
    require('lualine').setup{
        options = {theme = 'nord'},
        extensions = {'fugitive', 'fzf', 'nvim-tree'}
    }
EOF
    colorscheme nord
endfunction

" Color Scheme.
call NordTheme()

