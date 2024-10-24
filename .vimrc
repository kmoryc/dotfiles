set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"================ Cursor ================
let &t_SI = "\e[5 q"   " cursor in insert mode
let &t_EI = "\e[1 q"   " cursor in normal mode
let &t_SR = "\e[3 q"   " cursor in replace mode
let &t_ti .= "\e[2 q"  " cursor when vim starts
let &t_te .= "\e[5 q"  " cursor when vim exits

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
set number

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
set colorcolumn=80

"================ YCM ================
Plugin 'ycm-core/YouCompleteMe'
nmap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_autoclose_preview_window_after_insertion = 1
let $PYTHONPATH .= getcwd()

" Custom completion window behavior
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_stop_completion = ['<C-y>', '<UP>', '<DOWN>']

"================ Behavior ================
" Make search highlight all occurences
set hlsearch

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

