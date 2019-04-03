function! imselect#osascript#call(script, options) abort
  let Handler = function('imselect#osascript#handler')
  let jobid = async#job#start(['osascript', '-'], {
        \ 'on_stdout': get(a:options, 'on_stdout', Handler),
        \ 'on_stderr': get(a:options, 'on_stderr', Handler),
        \ 'on_exit': get(a:options, 'on_exit', Handler),
        \ })
  if jobid <= 0
    call imselect#print_error('osascript failed to start')
  endif
  call async#job#send(jobid, a:script)
endfunction

function! imselect#osascript#handler(jobid, data, event) abort
  if a:event ==# 'exit' && a:data != 0
    call imselect#print_error('invalid exit code from osascript: ' . a:data)
  endif
endfunction
