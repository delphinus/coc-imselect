if exists('g:loaded_imselect')
  finish
endif
let g:loaded_imselect = 1

let g:imselect#debug = get(g:, 'imselect_debug', g:imselect#debug)
let g:imselect#default_method = get(g:, 'imselect_default_method', g:imselect#default_method)

call imselect#get_color()
call imselect#start()

augroup Imselect
  autocmd!
  autocmd FocusGained call imselect#focus_gained()
  autocmd InsertEnter * call imselect#insert_enter()
  autocmd InsertLeave * call imselect#insert_leave()
  autocmd VimLeavePre * call imselect#close()
augroup END
