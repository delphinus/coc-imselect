let g:imselect#observer#path = g:imselect#bin_dir . '/observer'

function! imselect#observer#start() abort
  let jobid = jobstart(g:imselect#observer#path, {
        \ 'on_stdout': function('imselect#observer#out'),
        \ 'on_stderr': function('imselect#observer#out'),
        \ 'on_exit': function('imselect#observer#exit'),
        \ 'pty': v:true,
        \ 'width': 80,
        \ 'height': 30,
        \ 'TERM': 'xterm-color',
        \ })
  if jobid <= 0
    call imselect#print_error('observer failed to start')
  endif
endfunction

function! imselect#observer#out(jobid, data, event) abort
  if a:event ==# 'stderr'
    return
  endif
  for line in a:data
    call imselect#print_info(line)
    let parts = split(trim(line))
    if len(parts) != 2
      continue
    endif
    let g:imselect#current_lang = parts[0]
    let g:imselect#current_method = parts[1]
    if g:imselect#current_lang ==# 'en'
      if !empty(g:imselect#default_color)
        call imselect#set_color(g:imselect#default_color)
      endif
    else
      call imselect#set_color(g:imselect#highlights)
    endif
    return
  endfor
endfunction

function! imselect#observer#exit(jobid, data, event) abort
  if a:data != 0
    call imselect#print_error('invalid exit code from observer: ' . a:data)
  endif
endfunction
