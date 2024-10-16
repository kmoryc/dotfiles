set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"================ Colors ================
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on

let g:onedark_termcolors=256
let g:onedark_color_overrides = {
\ "background": {"gui": "#20242c", "cterm": "235", "cterm16": "0" }
\}

colorscheme onedark

"=============== Layout ================
Plugin 'preservim/nerdtree'
autocmd VimEnter * NERDTree | wincmd p
let NERDTreeShowHidden=1
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Vertical ruler
:set colorcolumn=80

"================ YCM ================
Plugin 'ycm-core/YouCompleteMe'

"================ Behavior ================
" Make backspace work
set backspace=indent,eol,start

" Show existing tab with 4 spaces width. Use 4 spaces for tab and '>' indent.
set tabstop=4
set shiftwidth=4
set expandtab

" Vertical split - newly opened pane to appear of the right
:set splitright

"================ | ================

call vundle#end()

filetype plugin indent on

