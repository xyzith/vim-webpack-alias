let s:plugindir = expand('<sfile>:p:h')

function! WebpackAliasGetAlias(rootDir, fileName)
  let l:result = system('tsx '.s:plugindir.'/configParser.ts '.a:rootDir.' '.a:fileName)
  let l:aliasStrs = split(l:result, "\n")
  let l:aliasList = []
  for i in l:aliasStrs
  let l:aliasList = l:aliasList + [split(i, ' ')]
  endfor
  return l:aliasList
endfunction

function! WebpackAliasInex()
  let l:rootDir = finddir('.git/..', expand('%:p:h').';')
  for i in s:webpackAliasList
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
  let l:configFile = ['vite.config.ts', 'webpack.config.js', 'vite.config.js']

  for f in l:configFile
    if filereadable(l:rootDir.'/'.f)
      let s:webpackAliasList = WebpackAliasGetAlias(l:rootDir, f)
      " fix @ not working
      setlocal isfname+=@-@
      set inex=WebpackAliasInex()
      break
    endif
  endfor
endfunction

call WebpackAliasIncludeAlias()
