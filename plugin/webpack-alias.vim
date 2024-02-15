function! WebpackAliasGetAlias(rootDir, fileName)
  let l:script = 'import(\"'.a:rootDir.'/'.a:fileName.'\").then((config) => {
    \ const l = config?.default({}, {})?.resolve?.alias || {};
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
  let l:configFile = ['webpack.config.js', 'vite.config.js']

  for f in l:configFile
    if filereadable(l:rootDir.'/'.f)
      let g:webpackAliasList = WebpackAliasGetAlias(l:rootDir, f)
      " fix @ not working
      setlocal isfname+=@-@
      set inex=WebpackAliasInex()
      break
    endif
  endfor
endfunction

call WebpackAliasIncludeAlias()
