function! imselect#osascript#call(script, options) abort
  echomsg 'h1'
  let Handler = function('imselect#osascript#handler')
  echomsg 'h2'
  let jobid = async#job#start('osascript -', {
        \ 'on_stdout': get(a:options, 'on_stdout', Handler),
        \ 'on_stderr': get(a:options, 'on_stderr', Handler),
        \ 'on_exit': get(a:options, 'on_exit', Handler),
        \ })
  echomsg 'h3'
  echomsg jobid
  if jobid <= 0
    call imselect#print_error('osascript failed to start')
  endif
  echomsg 'h4'
  call async#job#send(jobid, a:script)
endfunction

function! imselect#osascript#handler(jobid, data, event) abort
  if a:event ==# 'exit' && a:data != 0
    call imselect#print_error('invalid exit code from osascript: ' . a:data)
  endif
endfunction
