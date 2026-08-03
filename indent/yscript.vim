" YScript Vim indent
" 4 空格缩进：{ } 块、match/switch、case/default、else/elif、括号续行、预处理器

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal indentexpr=YScriptIndent()
setlocal indentkeys+=0=},0=),0=case,0=default,0=else,0=elif,o,O,e,!^F

" 跳过字符串 / 字节串 / 注释 / Shell 命令内的括号
function! YScriptIndentSkip() abort
  let l:syn = synIDattr(synID(line('.'), col('.'), 1), 'name')
  return l:syn =~# '^\(yscriptString\|yscriptBytes\|yscriptComment\|yscriptCommentBlock\|yscriptShellCommand\|yscriptShellVar\|yscriptInterpolation\)$'
endfunction

function! YScriptIndent() abort
  let l:lnum = v:lnum
  let l:prev = prevnonblank(l:lnum - 1)
  if l:prev == 0
    return 0
  endif

  let l:cur = getline(l:lnum)
  let l:prevline = getline(l:prev)
  let l:ind = indent(l:prev)
  let l:sw = shiftwidth()

  " 行首 }：与匹配的 { 对齐（找不到则回退一层）
  if l:cur =~ '^\s*}'
    call cursor(l:lnum, indent(l:lnum) + 1)
    let l:match = searchpairpos('{', '', '}', 'bWn', 'YScriptIndentSkip()')
    if l:match[0] > 0
      return indent(l:match[0])
    endif
    return max([l:ind - l:sw, 0])
  endif

  " 行首 )：与匹配的 ( 对齐
  if l:cur =~ '^\s*)'
    call cursor(l:lnum, indent(l:lnum) + 1)
    let l:match = searchpairpos('(', '', ')', 'bWn', 'YScriptIndentSkip()')
    if l:match[0] > 0
      return indent(l:match[0])
    endif
    return max([l:ind - l:sw, 0])
  endif

  " switch 的 case / default：紧跟在 switch { 后 → 进一层；
  " 上个 case 关闭后 → 保持；case 体内 → 回退一层
  if l:cur =~ '^\s*\(case\|default\)\>'
    if l:prevline =~ '{\s*$\|=>\s*$'
      return l:ind + l:sw
    endif
    if l:prevline =~ '^\s*}\s*$'
      return l:ind
    endif
    return max([l:ind - l:sw, 0])
  endif

  " else / elif：与对应 if 同级（上一行是 } 时保持同级）
  if l:cur =~ '^\s*\(else\|elif\)\>'
    if l:prevline =~ '^\s*}\s*$'
      return l:ind
    endif
    return max([l:ind - l:sw, 0])
  endif

  " 上一行以 { 或 => 结尾（块/分支未闭合）→ 新行加一层
  if l:prevline =~ '{\s*$\|=>\s*$'
    return l:ind + l:sw
  endif

  " 上一行以 ( 结尾 → 续行加一层
  if l:prevline =~ '(\s*$'
    return l:ind + l:sw
  endif

  return l:ind
endfunction
