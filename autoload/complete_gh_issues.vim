let s:re = '\v^\s+(\d+)\] (.+) \( .+ \)$'

function! s:make_candidate(str)
  let token = matchlist(a:str, s:re)
  return {'word': '#' . token[1], 'abbr': '#' . token[1] . ': ' . token[2]}
endfunction

function! complete_gh_issues#Complete(findstart, base)
  if a:findstart
    let line = getline('.')[: col('.')]
    let token = matchstr(getline('.')[: col('.')], '\v#\d*$')
    return strridx(line, token)
  endif
  if !exists('b:complete_gh_issues')
    let b:complete_gh_issues = []
    silent! let ret = system('hub issue')
    if v:shell_error ==# 0
      let b:complete_gh_issues = map(split(ret, "\n"), 's:make_candidate(v:val)')
    else
      echohl Error | echomsg substitute(ret, '[\r\n]', '', '') | echohl None
    endif
  endif
  return filter(copy(b:complete_gh_issues), 'stridx(v:val.word, a:base) == 0')
endfunction
