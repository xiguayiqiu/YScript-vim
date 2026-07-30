" YScript Vim syntax highlighting
" Based on VSCode extension syntax definitions
"
" Usage:
"   :set syntax=yscript
"   :set filetype=yscript

if exists("b:current_syntax")
  finish
endif

" ── 关键字 ────────────────────────────────────────────

" 控制流
syn keyword yscriptControlFlow if else elif switch case default
syn keyword yscriptControlFlow for while loop do break continue
syn keyword yscriptControlFlow return yield goto try catch finally
syn keyword yscriptControlFlow raise assert defer match

" 声明
syn keyword yscriptDeclaration let const var func init class struct
syn keyword yscriptDeclaration enum interface warp import package

" 导入/命名空间
syn keyword yscriptImport using as namespace in range

" 逻辑运算符
syn keyword yscriptLogical and or not xor

" 特殊运算符/关键字
syn keyword yscriptSpecial matches is new self this

" ── 类型 ──────────────────────────────────────────────

syn keyword yscriptType byte char short ushort int uint long ulong
syn keyword yscriptType float double bool string bytes list dict
syn keyword yscriptType ipv4 ipv6 map command error void

" ── 常量 ──────────────────────────────────────────────

syn keyword yscriptBoolean true false
syn keyword yscriptSpecial nil nan inf

" ── 注释 ──────────────────────────────────────────────

syn match   yscriptCommentLine "#.*$" contains=@Spell
syn match   yscriptCommentLine "//.*$" contains=@Spell
syn region  yscriptCommentBlock start="/\*" end="\*/" fold contains=@Spell

" ── Shell 命令（反引号） ─────────────────────────────

syn region yscriptShellCommand start="`" end="`" keepend contains=yscriptShellVar,yscriptShellFunc

" Shell 变量: $VAR, $(cmd), ${var}
syn match  yscriptShellVar "\$\w\+" contained
syn match  yscriptShellVar "\$([^)]*)" contained
syn match  yscriptShellVar "\${[^}]*}" contained

" Shell 常用命令高亮
syn match  yscriptShellFunc "\<nc\>" contained
syn match  yscriptShellFunc "\<nmap\>" contained
syn match  yscriptShellFunc "\<curl\>" contained
syn match  yscriptShellFunc "\<wget\>" contained
syn match  yscriptShellFunc "\<python\>" contained
syn match  yscriptShellFunc "\<python3\>" contained
syn match  yscriptShellFunc "\<ping\>" contained
syn match  yscriptShellFunc "\<bash\>" contained
syn match  yscriptShellFunc "\<sh\>" contained
syn match  yscriptShellFunc "\<ssh\>" contained
syn match  yscriptShellFunc "\<scp\>" contained
syn match  yscriptShellFunc "\<sed\>" contained
syn match  yscriptShellFunc "\<awk\>" contained
syn match  yscriptShellFunc "\<grep\>" contained
syn match  yscriptShellFunc "\<cat\>" contained
syn match  yscriptShellFunc "\<ls\>" contained
syn match  yscriptShellFunc "\<cd\>" contained
syn match  yscriptShellFunc "\<echo\>" contained
syn match  yscriptShellFunc "\<mkdir\>" contained
syn match  yscriptShellFunc "\<rm\>" contained
syn match  yscriptShellFunc "\<chmod\>" contained
syn match  yscriptShellFunc "\<chown\>" contained
syn match  yscriptShellFunc "\<tar\>" contained
syn match  yscriptShellFunc "\<gzip\>" contained
syn match  yscriptShellFunc "\<unzip\>" contained
syn match  yscriptShellFunc "\<xxd\>" contained
syn match  yscriptShellFunc "\<hexdump\>" contained
syn match  yscriptShellFunc "\<base64\>" contained
syn match  yscriptShellFunc "\<openssl\>" contained
syn match  yscriptShellFunc "\<iptables\>" contained
syn match  yscriptShellFunc "\<netstat\>" contained
syn match  yscriptShellFunc "\<ss\>" contained
syn match  yscriptShellFunc "\<ifconfig\>" contained
syn match  yscriptShellFunc "\<ip\>" contained
syn match  yscriptShellFunc "\<nslookup\>" contained
syn match  yscriptShellFunc "\<dig\>" contained
syn match  yscriptShellFunc "\<host\>" contained
syn match  yscriptShellFunc "\<traceroute\>" contained
syn match  yscriptShellFunc "\<whois\>" contained
syn match  yscriptShellFunc "\<hydra\>" contained
syn match  yscriptShellFunc "\<sqlmap\>" contained
syn match  yscriptShellFunc "\<gobuster\>" contained
syn match  yscriptShellFunc "\<dirb\>" contained
syn match  yscriptShellFunc "\<nikto\>" contained
syn match  yscriptShellFunc "\<wpscan\>" contained
syn match  yscriptShellFunc "\<powershell\>" contained
syn match  yscriptShellFunc "\<cmd\>" contained

" ── 字符串 ────────────────────────────────────────────

" 普通字符串 "..."
syn region yscriptString start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=yscriptEscape

" 字节字符串 b"..."
syn region yscriptBytesString start=+b"+ end=+"+ skip=+\\\\\|\\"+ contains=yscriptEscape

" 转义序列
syn match  yscriptEscape "\\[abfnrtv\\\"'?0]" contained
syn match  yscriptEscape "\\x[0-9a-fA-F]\{1,2}" contained
syn match  yscriptEscape "\\u[0-9a-fA-F]\{4}" contained
syn match  yscriptEscape "\\U[0-9a-fA-F]\{8}" contained
syn match  yscriptEscape "\\[0-7]\{1,3}" contained

" ── 数字 ──────────────────────────────────────────────

syn match  yscriptFloat "\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=\>"
syn match  yscriptHex  "\<0[xX][0-9a-fA-F]\+\>"
syn match  yscriptOct  "\<0[oO][0-7]\+\>"
syn match  yscriptBin  "\<0[bB][01]\+\>"
syn match  yscriptInt  "\<\d\+\>"

" ── 操作符 ────────────────────────────────────────────

" 管道
syn match  yscriptOperator "|>"

" 赋值
syn match  yscriptOperator "<<="
syn match  yscriptOperator ">>="
syn match  yscriptOperator "+="
syn match  yscriptOperator "-="
syn match  yscriptOperator "*="
syn match  yscriptOperator "/="
syn match  yscriptOperator "%="
syn match  yscriptOperator "&="
syn match  yscriptOperator "|="
syn match  yscriptOperator "^="
syn match  yscriptOperator "="

" 比较
syn match  yscriptOperator "=="
syn match  yscriptOperator "!="
syn match  yscriptOperator "<="
syn match  yscriptOperator ">="
syn match  yscriptOperator "<<"
syn match  yscriptOperator ">>"
syn match  yscriptOperator "[<>]"

" 位运算
syn match  yscriptOperator "[&|^~]"

" 算术
syn match  yscriptOperator "[+\-*/%]"

" 其他运算符
syn match  yscriptOperator "?\.\|??"
syn match  yscriptOperator "\."
syn match  yscriptOperator "@"
syn match  yscriptOperator "::"
syn match  yscriptOperator "=>"
syn match  yscriptOperator "->"
syn match  yscriptOperator "<-"
syn match  yscriptOperator "\.\.\|\.\.\."
syn match  yscriptOperator "|>"

" 测试操作符 -e -f -d 等
syn match  yscriptTestOp "-\%([efdgrwxshLbcpSzn]\)\%(eq\|ne\|gt\|lt\|ge\|le\)\="

" ── 分隔符 ────────────────────────────────────────────

syn match  yscriptDelimiter "[{}()\[\];,:]"

" ── 标识符/变量 ───────────────────────────────────────

" （函数调用使用默认颜色，不单独匹配避免冲突）

" ── 高亮定义（独立颜色，不受主题影响）──────────────

" 关键字  → 黄色 (REPL: \033[33m)
hi def yscriptControlFlow    ctermfg=11  guifg=#ffcc00
hi def yscriptDeclaration    ctermfg=11  guifg=#ffcc00
hi def yscriptImport         ctermfg=11  guifg=#ffcc00

" 逻辑运算符 → 亮黄 (REPL: \033[93m)
hi def yscriptLogical        ctermfg=228 guifg=#ffff87

" 类型  → 紫色 (REPL: \033[35m)
hi def yscriptType           ctermfg=13  guifg=#cc88ff

" 布尔/特殊常量 → 亮青 (REPL: \033[96m)
hi def yscriptBoolean        ctermfg=14  guifg=#66ccff
hi def yscriptSpecial        ctermfg=14  guifg=#66ccff

" 字符串 → 绿色 (REPL: \033[32m)
hi def yscriptString         ctermfg=10  guifg=#66ff66
hi def yscriptBytesString    ctermfg=10  guifg=#66ff66
hi def yscriptShellCommand   ctermfg=10  guifg=#66ff66

" 数字 → 亮紫 (REPL: \033[95m)
hi def yscriptFloat          ctermfg=213 guifg=#ff87ff
hi def yscriptHex            ctermfg=213 guifg=#ff87ff
hi def yscriptOct            ctermfg=213 guifg=#ff87ff
hi def yscriptBin            ctermfg=213 guifg=#ff87ff
hi def yscriptInt            ctermfg=213 guifg=#ff87ff

" 注释 → 灰色 (REPL: \033[90m)
hi def yscriptCommentLine    ctermfg=8   guifg=#888888
hi def yscriptCommentBlock   ctermfg=8   guifg=#888888

" 操作符 → 亮黄
hi def yscriptOperator       ctermfg=228 guifg=#ffff87
hi def yscriptTestOp         ctermfg=228 guifg=#ffff87

" 分隔符 → 白色
hi def yscriptDelimiter      ctermfg=15  guifg=#ffffff

" Shell 变量 → 青色
hi def yscriptShellVar       ctermfg=6   guifg=#44bbdd

" Shell 命令名 → 青色
hi def yscriptShellFunc      ctermfg=6   guifg=#44bbdd

" 转义序列 → 亮红
hi def yscriptEscape         ctermfg=9   guifg=#ff6666

" 函数调用使用默认颜色

let b:current_syntax = "yscript"
