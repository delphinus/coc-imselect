let g:imselect#bin_dir = resolve(expand('<sfile>:p:h') . '/../bin')
let g:imselect#current_lang = ''
let g:imselect#current_method = ''
let g:imselect#default_color = {}
 
function! imselect#start() abort
  call imselect#observer#start()
endfunction

function! imselect#select_input(method) abort
  call imselect#select#start(a:method)
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
  for line in a:data
    let parts = split(trim(line), ',\s*')
    if len(parts) == 3
      let g:imselect#default_color = {
            \ 'red': parts[0],
            \ 'green': parts[1],
            \ 'blue': parts[2],
            \ }
      return
    endif
  endfor
endfunction

function! imselect#print_error(msg) abort
  echohl WarningMsg | echomsg '[imselect] ' . a:msg | echohl None
endfunction
