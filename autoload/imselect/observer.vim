let g:imselect#default_color = {}
let s:lang = ''
let s:method = ''

function! imselect#observer#out(jobid, data, event) abort
  if a:event ==# 'stderr'
    return
  endif
  let parts = split(trim(a:data[-1]))
  if len(parts) != 2
    call imselect#print_error('invalid response from observer: ' . a:data[-1])
  endif
  let s:lang = parts[0]
  let s:method = parts[1]
  if s:lang ==# 'en'
    if !empty(g:imselect#default_color)
      call imselect#set_color(g:imselect#default_color)
    endif
  else
    call imselect#set_color(g:imselect#highlights)
  endif
endfunction

function! imselect#observer#exit(jobid, status, event) abort
  if status != 0
    call imselect#print_error('invalid exit code from observer: ' . status)
  endif
endfunction
