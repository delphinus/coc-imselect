if exists('g:loaded_imselect')
  finish
endif
let g:loaded_imselect = 1

let s:bin_dir = resolve(expand('<sfile>:p:h') . '../bin')
let g:imselect#observer = get(g:, 'imselect_observer', s:bin_dir . '/observer')
let g:imselect#select = get(g:, 'imselect_select', s:bin_dir . '/select')
