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
  return jobid
endfunction

function! imselect#select#handler(jobid, data, event) abort
  if a:event ==# 'exit' && a:data != 0
    call imselect#print_error('invalid exit code from select: ' . a:data)
  endif
endfunction

function! imselect#select#wait(method) abort
  let jobid = imselect#select#start(a:method)
  let results = async#job#wait(jobid)
  if results[0] != 0
    call imselect#print_error('invalid exit code from select: ' . status)
  endif
endfunction
