let s:jobid = 0
let g:imselect#observer#path = g:imselect#bin_dir . '/observer'

function! imselect#observer#start() abort
  let Handler = function('imselect#observer#handler')
  let s:jobid = async#job#start(g:imselect#observer#path, {
        \ 'on_stdout': Handler,
        \ 'on_stderr': Handler,
        \ 'on_exit': Handler,
        \ 'pty': v:true,
        \ 'width': 80,
        \ 'height': 30,
        \ 'TERM': 'xterm-color',
        \ })
  if s:jobid <= 0
    call imselect#print_error('observer failed to start')
  endif
endfunction

function! imselect#observer#stop() abort
  call async#job#stop(s:jobid)
  let s:jobid = 0
endfunction

function! imselect#observer#handler(jobid, data, event) abort
  call imselect#print_debug(a:event . ' in observer')
  if a:event !=# 'stdout'
    return
  endif
  for line in a:data
    call imselect#print_debug(line)
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
