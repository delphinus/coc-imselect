let g:imselect#select#path = g:imselect#bin_dir . '/select'

function! imselect#select#start(method) abort
  let Handler = function('imselect#select#handler')
  let jobid = async#job#start([g:imselect#select#path, a:method], {
        \ 'on_stdout': Handler,
        \ 'on_stderr': Handler,
        \ 'on_exit': Handler,
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

function! imselect#select#default() abort
  if g:imselect#current_lang ==# 'en'
    return
  endif
  call imselect#select#start(g:imselect#default_method)
endfunction

function! imselect#select#default_wait() abort
  let jobid = imselect#select#start(g:imselect#default_method)
  let results = async#job#wait([jobid])
  if results[0] != 0
    call imselect#print_error('invalid exit code from select: ' . results[0])
  endif
endfunction
