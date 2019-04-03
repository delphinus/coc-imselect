function! imselect#start_observer() abort
  let jobid = async#job#start(g:imselect#observer, {
        \ 'on_stdout': function('imselect#observer#out'),
        \ 'on_stderr': function('imselect#observer#out'),
        \ 'on_exit': function('imselect#observer#exit'),
        \ })
  if jobid <= 0
    call imselect#print_error('observer failed to start')
  endif
endfunction

function! imselect#select_input(method) abort
  let jobid = async#job#start(g:imselect#select . ' ' . a:method, {
        \ 'on_stdout': function('imselect#select#handler'),
        \ 'on_stderr': function('imselect#select#handler'),
        \ 'on_exit': function('imselect#select#handler'),
        \ })
  if jobid <= 0
    call imselect#print_error('select failed to start')
  endif
endfunction

function! imselect#set_color(color) abort
  if type(a:color) != v:dict
    call imselect#print_error('color should be dict')
    return
  endif
  call imselect#osascript#call(printf('tell application "iTerm"' . "\n" .
        \ '  tell current session of current window' . "\n" .
        \ '    set cursor color to {%s, %s, %s, 0}' . "\n" .
        \ '  end tell' . "\n" .
        \ 'end tell' . "\n",
        \ a:color.red, a:color.green, a:color.blue))
endfunction

function! imselect#get_color() abort
  call imselect#osascript#call('tell application "iTerm"' . "\n" .
        \ '  tell current session of current window' . "\n" .
        \ '    get cursor color' . "\n" .
        \ '  end tell' . "\n" .
        \ 'end tell' . "\n",
        \ {'on_stdout': function('imselect#read_default_color')})
endfunction

function! imselect#read_default_color(jobid, data, event) abort
  let parts = split(trim(a:data), ',\s*')
  if len(parts) != 3
    call imselect#print_error('invalid output from osascript: ' . a:data)
    return
  endif
  let g:imselect#default_color = {
        \ 'red': parts[0],
        \ 'green': parts[1],
        \ 'blue': parts[2],
        \ }
endfunction

function! imselect#print_error(msg) abort
  echohl WarningMsg | echomsg '[imselect] ' . a:msg | echohl None
endfunction
