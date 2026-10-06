" YScript Vim plugin
"
" Features:
"   - 语法高亮（syntax/yscript.vim）
"   - 保存时异步语法检查（默认关闭，需显式开启）
"   - 手动触发 :YscriptCheck（默认绑 <F6>）
"
" No external dependencies required (No Node.js, no LSP server)

if exists('g:loaded_yscript_plugin')
  finish
endif
let g:loaded_yscript_plugin = 1

" ── 配置项（可在 .vimrc 中提前覆盖）────────────────────
"
" g:yscript_check_on_save   保存时自动检查（默认 0：关闭）
" g:yscript_executable      ysc 可执行文件路径（默认 PATH 中的 ysc）
" g:yscript_quickfix        1 = 错误写入 quickfix 列表（默认 1）
" g:yscript_keymap          手动触发键（默认 <F6>），'' 关闭映射
" g:yscript_extra_args      ysc -c 之后的额外参数（默认 ''）

if !exists('g:yscript_check_on_save') | let g:yscript_check_on_save = 0 | endif
if !exists('g:yscript_quickfix')       | let g:yscript_quickfix = 1       | endif
if !exists('g:yscript_keymap')         | let g:yscript_keymap = '<F6>'    | endif
if !exists('g:yscript_extra_args')     | let g:yscript_extra_args = ''   | endif

" 自动探测 ysc 可执行文件
function! s:detect_ysc() abort
  if exists('g:yscript_executable') && !empty(g:yscript_executable)
    return g:yscript_executable
  endif
  return executable('ysc') ? 'ysc' : ''
endfunction
let s:ysc_bin = s:detect_ysc()

" ── 保存时异步语法检查（默认关闭）─────────────────────

augroup yscript-plugin
  autocmd!
  if g:yscript_check_on_save && !empty(s:ysc_bin)
    autocmd BufWritePost *.ys,*.yscript call s:yscript_check(0)
  endif
augroup END

" ── 手动触发：:YscriptCheck [file] ─────────────────────
" 不带参数则检查当前 buffer 对应的文件

if !empty(s:ysc_bin)
  command! -nargs=? -bar YscriptCheck call s:yscript_check(1, <q-args>)
endif

if !empty(g:yscript_keymap) && !empty(s:ysc_bin)
  execute 'nnoremap <silent> ' . g:yscript_keymap . ' :YscriptCheck<CR>'
endif

" ── 核心检查函数 ──────────────────────────────────────

let s:running_job = 0

function! s:yscript_check(force, ...) abort
  if empty(s:ysc_bin)
    if a:force
      echohl WarningMsg
      echomsg 'YScript: 找不到 ysc 可执行文件（设置 g:yscript_executable 或把 ysc 放到 PATH）'
      echohl None
    endif
    return
  endif

  let l:file = a:0 > 0 && !empty(a:1) ? a:1 : expand('%:p')
  if empty(l:file) || !filereadable(l:file)
    return
  endif

  " 已经在跑一个就停掉，避免连续 :w 堆 job
  if s:running_job
    if has('nvim')
      silent! call jobstop(s:running_job)
    elseif has('job')
      silent! call job_stop(s:running_job)
    endif
    let s:running_job = 0
  endif

  let l:cmd = [s:ysc_bin, '-c']
  if !empty(g:yscript_extra_args)
    call extend(l:cmd, split(g:yscript_extra_args))
  endif
  call add(l:cmd, l:file)

  if has('nvim')
    call s:yscript_run_nvim(l:cmd, l:file, a:force)
  elseif has('job') && has('channel')
    call s:yscript_run_vim(l:cmd, l:file, a:force)
  else
    call s:yscript_run_sync(l:cmd, l:file, a:force)
  endif
endfunction

" ── Neovim：jobstart + on_stdout/on_stderr/on_exit ────

let s:buf_nvim = ''

function! s:yscript_run_nvim(cmd, file, force) abort
  let s:buf_nvim = ''
  let s:running_job = jobstart(a:cmd, {
        \ 'on_stdout': function('s:on_stdout_nvim'),
        \ 'on_stderr': function('s:on_stderr_nvim'),
        \ 'on_exit':   function('s:on_exit_nvim', [a:file, a:force]),
        \ })
endfunction

function! s:on_stdout_nvim(job_id, data, _event) abort
  let s:buf_nvim .= join(a:data, "\n") . "\n"
endfunction

function! s:on_stderr_nvim(job_id, data, _event) abort
  let s:buf_nvim .= join(a:data, "\n") . "\n"
endfunction

function! s:on_exit_nvim(file, force, job_id, code, _event) abort
  let s:running_job = 0
  let l:out = s:buf_nvim
  let s:buf_nvim = ''
  call s:yscript_show(a:file, l:out, a:code, a:force)
endfunction

" ── Vim 8/9：job_start + stdout_cb / stderr_cb / exit_cb ─
"
" stdout_cb/stderr_cb 在 nl 模式下按行触发多次，单纯 echo 会重复。
" 这里把每片 chunk 累积起来，到 exit_cb 一次性展示。

function! s:yscript_run_vim(cmd, file, force) abort
  let s:last_out = ''
  let s:running_job = job_start(a:cmd, {
        \ 'in_mode':   'nl',
        \ 'out_mode':  'nl',
        \ 'err_mode':  'nl',
        \ 'stdout_cb': function('s:on_stdout_vim'),
        \ 'stderr_cb': function('s:on_stderr_vim'),
        \ 'exit_cb':   function('s:on_exit_vim', [a:file, a:force]),
        \ })
endfunction

function! s:on_stdout_vim(ch, msg) abort
  let s:last_out .= a:msg
endfunction

function! s:on_stderr_vim(ch, msg) abort
  let s:last_out .= a:msg
endfunction

function! s:on_exit_vim(file, force, ch, msg) abort
  let s:running_job = 0
  call s:yscript_show(a:file, s:last_out, v:shell_error, a:force)
  let s:last_out = ''
endfunction

" ── 同步兜底（极老 Vim） ──────────────────────────────

function! s:yscript_run_sync(cmd, file, force) abort
  let l:out = system(join(map(a:cmd, 'shellescape(v:val)'), ' ') . ' 2>&1')
  let l:code = v:shell_error
  call s:yscript_show(a:file, l:out, l:code, a:force)
endfunction

" ── 展示结果 ──────────────────────────────────────────
" 收集到的 stdout/stderr 在用户主动触发（force=1）时写 quickfix + 提示；
" 被动保存触发（force=0）时只静默写 quickfix。

" 剥离 ANSI 转义（esc 颜色码）+ 末尾 NUL
function! s:strip_ansi(s) abort
  let l:s = substitute(a:s, '\e\[[0-9;]*[a-zA-Z]', '', 'g')
  return tr(l:s, "\x00", '')
endfunction

function! s:yscript_show(file, out, code, force) abort
  let l:out = s:strip_ansi(a:out)

  if empty(l:out)
    if a:force
      echohl MoreMsg
      echomsg 'YScript: ' . a:file . ' OK'
      echohl None
    endif
    return
  endif

  if g:yscript_quickfix
    call s:yscript_to_qf(a:file, l:out)
  endif

  if a:force
    echohl WarningMsg
    echomsg 'YScript: ' . substitute(l:out, '\n', ' | ', 'g')
    echohl None
  endif
endfunction

" 把 ysc -c 的输出写入 quickfix
" 优先匹配 "file:line:col: msg"，否则回落到 "file: msg"

function! s:yscript_to_qf(file, out) abort
  let l:list = []
  for l:line in split(a:out, "\n")
    if l:line =~ '^\s*$'
      continue
    endif
    " 形如 /abs/path.ys:12:5: 错误信息
    let l:m = matchlist(l:line, '^\([^:]\+\):\(\d\+\):\(\d\+\):\s*\(.*\)$')
    if !empty(l:m)
      call add(l:list, {
            \ 'module':   l:m[1],
            \ 'lnum':     str2nr(l:m[2]),
            \ 'col':      str2nr(l:m[3]),
            \ 'text':     l:m[4],
            \ 'valid':    1,
            \ })
      continue
    endif
    " 形如 /abs/path.ys: 错误信息（ysc 当前格式：缺行号）
    let l:m = matchlist(l:line, '^\(\S\+\):\s*\(.*\)$')
    if !empty(l:m) && (l:m[1] =~ '\.\(ys\|yscript\)$' || stridx(l:m[1], '/') >= 0 || stridx(l:m[1], '.ys') > 0)
      call add(l:list, {
            \ 'module':   l:m[1],
            \ 'lnum':     1,
            \ 'col':      1,
            \ 'text':     l:m[2],
            \ 'valid':    1,
            \ })
    else
      call add(l:list, {'text': l:line, 'valid': 1})
    endif
  endfor

  if empty(l:list)
    return
  endif

  if exists('*setqflist')
    try
      " Neovim 0.10+ 要求 list 项中包含 valid=1；0.12 字段名是 module
      let r = setqflist(l:list, 'r')
    catch
      try
        let r = setqflist(l:list, ' ')
      catch
      endtry
    endtry
  elseif exists('*setloclist')
    call setloclist(0, l:list, ' ')
  endif
endfunction