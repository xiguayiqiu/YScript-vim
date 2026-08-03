" YScript Vim plugin
"
" Features:
"   - Syntax check on save (uses `ysc -c`)
"
" No external dependencies required (No Node.js, no LSP server)

if exists('g:loaded_yscript_plugin')
  finish
endif
let g:loaded_yscript_plugin = 1

" ── Syntax check on save ──────────────────────────────

augroup yscript-plugin
  autocmd!
  autocmd BufWritePost *.ys,*.yscript call s:yscript_check()
augroup END

function! s:yscript_check() abort
  let l:file = expand('%:p')
  if !executable('ysc')
    return
  endif
  let l:out = system('ysc -c ' . shellescape(l:file) . ' 2>&1')
  if v:shell_error
    echohl WarningMsg
    echomsg 'YScript: ' . substitute(l:out, '\n', ' | ', 'g')
    echohl None
  endif
endfunction
