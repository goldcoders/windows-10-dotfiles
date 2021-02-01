call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
call plug#end()

let mapleader =" "

"-------------FILE HISTORY--------------"
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set autowrite  "Save on buffer switch "

"-------------GENERAL SETTINGS--------------"
set showmode                    " always show what mode we're currently editing in "
set nowrap                      " don't wrap lines "
set backspace=indent,eol,start  " allow backspacing over everything in insert mode "
set visualbell                  " don't beep "
set noerrorbells                " don't beep "
set mouse=a                     " Allows Your To Use Mouse "
set timeout timeoutlen=1000 ttimeoutlen=10
set bg=dark
set go=a
set clipboard=unnamedplus
set display+=lastline

"-------------SEARCH--------------"
highlight Search cterm=underline
set ignorecase                              " ignore case when searching "
set smartcase                               " ignore case if search pattern is all lowercase "
set hlsearch                                " Highlight all matched terms. "
set incsearch                               " Incrementally highlight, as we type. "

nnoremap ,<leader> :set hlsearch!<CR>

"-------------INDENTION--------------"
set autoindent                  " always set autoindenting on "
set copyindent                  " copy the previous indentation on autoindenting "


"-------------TABS--------------"
set smarttab
set tabstop=4                   " a tab is four spaces "
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces "
set expandtab                   " expand tabs by default (overloadable per file type later) "
set shiftwidth=4                " number of spaces to use for autoindenting "
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>' "

" Some basics:
nnoremap c "_c
set t_Co=256
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
" Enable autocompletion:
set wildmode=longest,list,full
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

"-------------Split Management--------------"
" https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
" Split Default Layout"
set splitbelow
set splitright
set fillchars+=stl:\ ,stlnc:\ "
hi VertSplit cterm=none ctermfg=red ctermbg=none

" Opening splits "
nmap vsp :vsplit<cr>
nmap sp :split<cr>

" Shortcutting split navigation, saving a keypress:
" has been set with window+shift+[hjkl]
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
set noswapfile


" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300


" folding code tuts
" to select code inside a block {} use `viB` if you want to include the other vaB
" then to fold the code use `zf`

let g:python3_host_prog="C:\\Users\\masterpowers\\scoop\\shims\\python3"
let g:python_host_prog="C:\\Users\\masterpowers\\scoop\\shims\\python2"

" We Set myvirmc on our env global 
" we will just use :e $myvimrc in vscode or :source $myvimrc

" Prevent CTRL+Z suspending Vim
nnoremap <c-z> <nop>

"anoher one

" Buffer Management
nmap <silent> bp :bp<CR>
nmap <silent> bn :bn<CR>
nmap <silent> bl :ls<CR>

" go back to any open buffer using Ngb where N is the number
let c = 1
while c <= 99
  execute "nnoremap " . c . "gb :" . c . "b\<CR>"
  let c += 1
endwhile


"Pasting large amounts of text into Vim "
nnoremap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
nnoremap <silent> S <Cmd>call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
nnoremap <silent> F <Cmd>call VSCodeNotify('Find')<CR>

let g:EasyMotion_do_mapping = 1
