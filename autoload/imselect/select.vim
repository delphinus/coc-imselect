let g:imselect#select#path = g:imselect#bin_dir . '/select'

function! imselect#select#start(method) abort
  let jobid = async#job#start([g:imselect#select#path, a:method], {
        \ 'on_stdout': function('imselect#select#handler'),
        \ 'on_stderr': function('imselect#select#handler'),
        \ 'on_exit': function('imselect#select#handler'),
        \ })
  if jobid <= 0
    call imselect#print_error('select failed to start')
  endif
endfunction

function! imselect#select#handler(jobid, data, event) abort
  if a:event ==# 'exit' && a:data != 0
    call imselect#print_error('invalid exit code from select: ' . a:data)
  endif
endfunction
