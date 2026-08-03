" YScript ftplugin：Tab / 回车换行 / 缩进

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Tab = 4 空格（与 yscript 格式化默认一致）
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal shiftround

" 回车自动缩进（具体缩进由 indent/yscript.vim 的 indentexpr 计算）
setlocal autoindent
setlocal nosmartindent
setlocal nocindent

" # 注释：回车时自动延续为 '# '
setlocal comments=b:#
setlocal formatoptions+=r
setlocal textwidth=0

" 便于其他插件（如 commentary.vim）识别注释
let &l:commentstring = '# %s'
