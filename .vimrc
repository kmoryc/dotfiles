set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"=============== Layout ================
call g:lib#SetupOnedarkColorScheme()
call g:lib#SetupNERDTree()

set number " Numbering lines
set colorcolumn=80 " Vertical ruler

"================ Navigation ================
" Scrolling settings
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Navigation between windows
nmap <TAB> <C-w>w
nmap <S-TAB> <C-w><S-w>

" Window aliases
nmap <leader>s :vsplit<CR>
nmap <leader>z :split<CR>

"================ Behavior ================
call g:lib#SetupYCM()

" Cursor
let &t_SI = "\e[5 q"   " cursor in insert mode
let &t_EI = "\e[1 q"   " cursor in normal mode
let &t_SR = "\e[3 q"   " cursor in replace mode
let &t_ti .= "\e[2 q"  " cursor when vim starts
let &t_te .= "\e[5 q"  " cursor when vim exits

" Git
Plugin 'tpope/vim-fugitive'
nmap <leader>gs :G status
nmap <leader>gd :G diff
nmap <leader>gl :G --no-pager log --oneline -10

" Make search highlight all occurences
set hlsearch
" hlsearch aliases
nmap <leader>/ :nohlsearch<CR>

" Make backspace work
set backspace=indent,eol,start

" Indent settings
set autoindent
set smartindent
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Vertical split - newly opened pane to appear of the right
set splitright

"================ | ================

call vundle#end()

filetype plugin indent on

