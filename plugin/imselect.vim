if exists('g:loaded_imselect')
  finish
endif
let g:loaded_imselect = 1

call imselect#get_color()
call imselect#start()
