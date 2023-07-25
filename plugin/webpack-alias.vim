function! WebpackAliasGetAlias(rootDir)
  let l:script = 'import(\"'.a:rootDir.'/webpack.config.js\").then((config) => {
    \ const l = config?.default(null, {})?.resolve?.alias || {};
    \ Object.entries(l).forEach(([k, v]) => console.log(k, v))
    \ })'
  let l:result = system('node -e "'.l:script.'"')
  let l:aliasStrs = split(l:result, "\n")
  let l:aliasList = []
  for i in l:aliasStrs
    let l:aliasList = l:aliasList + [split(i, ' ')]
  endfor
  return l:aliasList
endfunction

function! WebpackAliasInex()
  let l:rootDir = finddir('.git/..', expand('%:p:h').';')
  echo fnameescape(v:fname)
  for i in g:webpackAliasList
    let l:alias = i[0]
    let l:path = i[1]
    if v:fname =~? '^'.l:alias
      return substitute(v:fname, l:alias, l:path,'')
    endif
  endfor
  return v:fname
endfunction

function! WebpackAliasIncludeAlias()
  let l:rootDir = finddir('.git/..', expand('%:p:h').';')

  if filereadable(l:rootDir.'/webpack.config.js')
    let g:webpackAliasList = WebpackAliasGetAlias(l:rootDir)
    " fix @ not working
    setlocal isfname+=@-@
    set inex=WebpackAliasInex()
  endif
endfunction

call WebpackAliasIncludeAlias()
