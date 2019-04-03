function! imselect#select#handler(jobid, data, event) abort
  if a:event ==# 'exit' && a:data != 0
    call imselect#print_error('invalid exit code from select: ' . a:data)
  endif
endfunction
