function! lib#SetupOnedarkColorScheme()
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
endfunction


function! lib#SetupNERDTree()
  Plugin 'preservim/nerdtree'

  autocmd VimEnter * NERDTree
  nnoremap <C-n> :NERDTree<CR>
  nnoremap <C-t> :NERDTreeToggle<CR>

  " Open the existing NERDTree on each new tab.
  autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

  " Exit Vim if NERDTree is the only window remaining in the only tab.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif  

  let g:NERDTreeShowHidden=1
endfunction


function! lib#SetupYCM()
  Plugin 'ycm-core/YouCompleteMe'

  nmap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>

  let g:ycm_autoclose_preview_window_after_insertion = 1
  let $PYTHONPATH .= getcwd()
  let g:ycm_key_list_select_completion = ['<TAB>']
  let g:ycm_key_list_stop_completion = ['<C-y>', '<ENTER>']
endfunction

