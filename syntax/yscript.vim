" YScript Vim syntax highlighting
" Full syntax support for YScript InfoSec scripting language
" Last updated: 2026-07

if exists("b:current_syntax")
  finish
endif

" ── 注释 ────────────────────────────────────────────
" YScript 使用 # 行注释，支持 #* *# 块注释
syn match   yscriptComment      "#.*$" contains=@Spell
syn region  yscriptCommentBlock start="#\*" end="\*#" fold contains=@Spell

" ── Shell 命令（反引号）───────────────────────────
syn region yscriptShellCommand  start="`" end="`" keepend contains=yscriptShellVar,yscriptShellFunc,yscriptShellCmd

syn match  yscriptShellVar      "\$\w\+" contained
syn match  yscriptShellVar      "\$([^)]*)" contained
syn match  yscriptShellVar      "\${[^}]*}" contained

" Shell 网安常用命令高亮
syn keyword yscriptShellCmd contained nc nmap curl wget python python3 ping bash sh ssh scp
syn keyword yscriptShellCmd contained sed awk grep cat ls cd echo mkdir rm chmod chown
syn keyword yscriptShellCmd contained tar gzip unzip xxd hexdump base64 openssl
syn keyword yscriptShellCmd contained iptables netstat ss ifconfig ip nslookup dig host
syn keyword yscriptShellCmd contained traceroute whois hydra sqlmap gobuster dirb nikto wpscan
syn keyword yscriptShellCmd contained powershell cmd jq timeout find xargs tee sort uniq wc head tail
syn keyword yscriptShellCmd contained strings objdump readelf ltrace strace tcpdump
syn keyword yscriptShellCmd contained metasploit msfconsole msfvenom searchsploit
syn keyword yscriptShellCmd contained john hashcat aircrack-ng reaver bettercap responder

hi def yscriptShellCmd      ctermfg=6   guifg=#44bbdd

" ── 字符串 ────────────────────────────────────────────

syn region yscriptString     start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=yscriptEscape,yscriptInterpolation
syn region yscriptBytes      start=+b"+ end=+"+ skip=+\\\\\|\\"+ contains=yscriptEscape

" 字符串插值 {var}
syn match  yscriptInterpolation "{[^}]*}" contained

" 转义序列
syn match  yscriptEscape     "\\[abfnrtv\\\"'?0]" contained
syn match  yscriptEscape     "\\x[0-9a-fA-F]\{1,2}" contained
syn match  yscriptEscape     "\\u[0-9a-fA-F]\{4}" contained
syn match  yscriptEscape     "\\U[0-9a-fA-F]\{8}" contained

" ── 数字 ──────────────────────────────────────────────

syn match  yscriptFloat      "\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=\>"
syn match  yscriptHex        "\<0[xX][0-9a-fA-F]\+\>"
syn match  yscriptOct        "\<0[oO][0-7]\+\>"
syn match  yscriptBin        "\<0[bB][01]\+\>"
syn match  yscriptInt        "\<\d\+\>"

" ── 关键字全（按分类）──────────────────────────────

" 程序结构
syn keyword yscriptStatement  package import as

" 变量与常量
syn keyword yscriptStatement  let const

" 函数定义
syn keyword yscriptStatement  func return defer yield init main

" 流程控制
syn keyword yscriptConditional if else elif switch case default match
syn keyword yscriptRepeat      for while loop in range break continue goto

" 异常处理
syn keyword yscriptException  panic recover assert

" 并发（warp）
syn keyword yscriptStatement  warp

" 类型定义
syn keyword yscriptStatement  struct enum interface this

" 泛型标记（无运行时强制）
" 用户通过 list<int>, dict<string,int> 标注

" 逻辑运算
syn keyword yscriptBoolean    true false
syn keyword yscriptLogical    and or not xor

" 特殊值
syn keyword yscriptSpecial    nil nan inf

" 命名空间（用于 import 语句）
syn keyword yscriptNamespace  io net http ssl raw json regex binary
syn keyword yscriptNamespace  encoding crypto aes rsa compress
syn keyword yscriptNamespace  yaml toml ini sync time rand sys os
syn keyword yscriptNamespace  path strings array from log stdio color
syn keyword yscriptNamespace  ffi reflect errors cuda

" ── 类型 ──────────────────────────────────────────────

syn keyword yscriptType       byte char short ushort int uint long ulong
syn keyword yscriptType       float double bool string bytes list dict
syn keyword yscriptType       ipv4 ipv6 error void any

" ── 内置函数 ──────────────────────────────────────

" 基础 I/O
syn keyword yscriptBuiltin    print println printf sprintf

" 类型转换
syn keyword yscriptBuiltin    string int float bool byte hex char

" 元编程
syn keyword yscriptBuiltin    len type eval next recover assert

" IP 构造
syn keyword yscriptBuiltin    ipv4 ipv6

" ── 操作符 ────────────────────────────────────────────

" 管道
syn match  yscriptOperator    "|>"

" 复合赋值
syn match  yscriptOperator    "<<=\|>>="
syn match  yscriptOperator    "+="
syn match  yscriptOperator    "-="
syn match  yscriptOperator    "*="
syn match  yscriptOperator    "/="
syn match  yscriptOperator    "%="
syn match  yscriptOperator    "&=\||=\|^="
syn match  yscriptOperator    "="

" 比较
syn match  yscriptOperator    "==\|!="
syn match  yscriptOperator    "<=\|>="
syn match  yscriptOperator    "<<\|>>"
syn match  yscriptOperator    "<\|>"

" 位运算
syn match  yscriptOperator    "[&|^~]"

" 算术
syn match  yscriptOperator    "[+\-*/%]"

" 空安全 / 成员 / 指针
syn match  yscriptOperator    "?\.\|??"
syn match  yscriptOperator    "\.\|::"
syn match  yscriptOperator    "@>"
syn match  yscriptOperator    "@"

" 箭头和范围
syn match  yscriptOperator    "->"
syn match  yscriptOperator    "\.\.\|\.\.\."

" Test 表达式: -e -f -d -r -w -x -s -L -h -b -c -p -S -u -g -k
" -nt -ot -ef -z -n = != -eq -ne -gt -lt -ge -le --readonly --system --archive
syn match  yscriptTestOp      "--\?[a-zA-Z][a-zA-Z-]*"

" ── 分隔符 ────────────────────────────────────────────

syn match  yscriptDelimiter   "[{}()\[\];,:]"

" ── 全局常量 ─────────────────────────────────────

syn keyword yscriptConstant   LAST_EXIT_CODE __FILE__ __LINE__ OS ARCH VERSION ENV

" ── 高亮定义 ──────────────────────────────

" 关键字 (声明/控制流) → 黄色
hi def yscriptStatement       ctermfg=11  guifg=#ffcc00
hi def yscriptConditional     ctermfg=11  guifg=#ffcc00
hi def yscriptRepeat          ctermfg=11  guifg=#ffcc00
hi def yscriptException       ctermfg=11  guifg=#ffcc00

" 类型 → 紫色
hi def yscriptType            ctermfg=13  guifg=#cc88ff

" 内置函数 → 亮蓝
hi def yscriptBuiltin         ctermfg=12  guifg=#6699ff

" 命名空间 → 青色
hi def yscriptNamespace       ctermfg=6   guifg=#66cccc

" 逻辑关键字 → 亮黄
hi def yscriptLogical         ctermfg=228 guifg=#ffff87

" 布尔/特殊常量 → 亮青
hi def yscriptBoolean         ctermfg=14  guifg=#66ccff
hi def yscriptSpecial         ctermfg=14  guifg=#66ccff
hi def yscriptConstant        ctermfg=14  guifg=#66ccff

" 字符串/bytes/Shell → 绿色
hi def yscriptString          ctermfg=10  guifg=#66ff66
hi def yscriptBytes           ctermfg=10  guifg=#66ff66
hi def yscriptShellCommand    ctermfg=10  guifg=#66ff66

" 字符串插值 → 亮绿
hi def yscriptInterpolation   ctermfg=120 guifg=#88ff88

" 数字 → 亮紫
hi def yscriptFloat           ctermfg=213 guifg=#ff87ff
hi def yscriptHex             ctermfg=213 guifg=#ff87ff
hi def yscriptOct             ctermfg=213 guifg=#ff87ff
hi def yscriptBin             ctermfg=213 guifg=#ff87ff
hi def yscriptInt             ctermfg=213 guifg=#ff87ff

" 注释 → 灰色
hi def yscriptComment         ctermfg=8   guifg=#888888
hi def yscriptCommentBlock    ctermfg=8   guifg=#888888

" 操作符 → 亮黄
hi def yscriptOperator        ctermfg=228 guifg=#ffff87
hi def yscriptTestOp          ctermfg=228 guifg=#ffff87

" 分隔符 → 白色
hi def yscriptDelimiter       ctermfg=15  guifg=#ffffff

" Shell 变量 → 青色
hi def yscriptShellVar        ctermfg=6   guifg=#44bbdd

" Shell 函数 → 青色
hi def yscriptShellFunc       ctermfg=6   guifg=#44bbdd

" 转义序列 → 亮红
hi def yscriptEscape          ctermfg=9   guifg=#ff6666

let b:current_syntax = "yscript"
