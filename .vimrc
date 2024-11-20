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
nmap <leader>bs :belowright split<CR>

"================ Behavior ================
call g:lib#SetupYCM()

" Cursor
let &t_SI = "\e[5 q"   " cursor in insert mode
let &t_EI = "\e[1 q"   " cursor in normal mode
let &t_SR = "\e[3 q"   " cursor in replace mode
let &t_ti .= "\e[2 q"  " cursor when vim starts
let &t_te .= "\e[5 q"  " cursor when vim exits
set whichwrap+=<,>,[,] " let the left/right arrows go to newline

" Git
Plugin 'tpope/vim-fugitive'
nmap <leader>gits :G status
let GIT_DEFAULT_BRANCH = "master"
nmap <leader>gitd :G diff
nmap <leader>gitl :G --no-pager log --oneline -10
"nmap <leader>gle :G --no-pager log --oneline --pretty=format:"%C(Yellow)%h%C(reset)%x20|%x20%ad%x20|%x20%ae%x20|%x20%s" --date=short -10"
"nmap <leader>glee :G --no-pager log --oneline --pretty=format:"%C(Yellow)%h%C(reset)%x20|%x20%ad%x20|%x20%ae%x20|%x20%s" --date=format:'%Y-%m-%d %H:%M:%S' -10"
nmap <leader>gitau :G add -u
"nmap <leader>gitc :G add -u && :G commit
nmap <leader>gitam :G add -u <bar> :G commit --amend
nmap <leader>gitr :G push origin HEAD:refs/for/master
nmap <leader>gitamp :G add -u <bar> :G commit --amend --no-edit <bar> :G push origin HEAD:refs/for/master
nmap <leader>gitp :G push origin master
nmap <leader>gitpp :G add -u <bar> :G commit --amend --no-edit <bar> :G push origin master
nmap <leader>giturl :G remote -v


"================ Search ================
nmap <leader>m :copen<CR>
Plugin 'mileszs/ack.vim'
nmap <leader>g :Ack<SPACE>
let g:ackprg = 'ag --nogroup --nocolor --column'

set incsearch     "Find the next match as we type the search
set hlsearch      "Highlight all occurrences
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

"================ | ================

call vundle#end()

filetype plugin indent on

