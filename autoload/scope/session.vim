vim9script
scriptencoding utf-8

import autoload 'scope/popup.vim'

var scope_session_dir = get(g:, 'scope_session_dir', '~/.scope_session')

export def SaveOrCreateSession(newsession: string = null_string)
  var targetsession: string
  if !empty(newsession)
    targetsession = scope_session_dir .. '/' .. newsession
  elseif !empty(v:this_session)
    targetsession = v:this_session
  else
    targetsession = g:scope_session_dir .. '/' .. input('Session name: ')
  endif
  execute 'mks! ' .. targetsession
  echo ' '
  echo 'Saved session to: ' .. targetsession
enddef

export def Session(profile: string = null_string)
  var filelist = (scope_session_dir .. '/*')->glob()->split()
  var sessions = []
  for file in filelist
    sessions->add({text: file})
  endfor
  popup.NewFilterMenu("session", sessions,
    (res, key) => {
      silent execute 'source ' .. res.text
    },
    (winid, _) => {
      win_execute(winid, $"syn match FilterMenuLineNr '(\\d\\+)$'")
      hi def link FilterMenuLineNr Comment
    })
enddef
