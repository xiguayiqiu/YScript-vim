" YScript Vim syntax highlighting
" Full syntax support for YScript InfoSec scripting language
" Last updated: 2026-08
"
" 语法范围对照 YScript Go 词法器 (yscript/internal/lexer) 与 doc/ 文档：
"   - 关键字 var/using/namespace/do/class/map/matches/is
"     try/catch/finally/raise/self
"   - 预处理器指令 #if/#elif/#else/#endif/#!permit (internal/preproc)
"   - 插值字符串 $"..." 与 ${expr}（TOKEN_INTERP_START）
"   - bytes 的 base64 前缀 b"base64:..."
"   - 正则字面量 /pattern/flags（TOKEN_REGEXP）
"   - 标签 label:（TOKEN_LABEL）
"   - 命名空间函数 io.read_file、命名空间常量 io.Stdin / time.DAY
"   - Err* 错误码常量（doc/18）

if exists("b:current_syntax")
  finish
endif

" ── 注释 ────────────────────────────────────────────
" YScript 使用 # 行注释，支持 #* *# 块注释
" 用 region 而非 match，避免注释内出现数字/字符串/正则被二次高亮
syn region  yscriptComment      start="#" end="$" contains=@Spell
syn region  yscriptCommentBlock start="#\*" end="\*#" fold contains=@Spell

" ── 预处理器指令（internal/preproc: #if/#elif/#else/#endif/#!permit）──
syn match   yscriptPreproc      "^[ \t]*\zs#if\>"
syn match   yscriptPreproc      "^[ \t]*\zs#elif\>"
syn match   yscriptPreproc      "^[ \t]*\zs#else\>"
syn match   yscriptPreproc      "^[ \t]*\zs#endif\>"
syn match   yscriptPreproc      "^[ \t]*\zs#!\?permit\>"

" ── Shell 命令（反引号）───────────────────────────
syn region yscriptShellCommand  start="`" end="`" keepend contains=yscriptShellVar,yscriptShellFunc,yscriptShellCmd,yscriptShellEscape

syn match  yscriptShellVar      "\$\w\+" contained
syn match  yscriptShellVar      "\$([^)]*)" contained
syn match  yscriptShellVar      "\${[^}]*}" contained
syn match  yscriptShellEscape   "\\\\`" contained

" Shell 网安常用命令高亮
syn keyword yscriptShellCmd contained nc nmap curl wget python python3 ping bash sh ssh scp
syn keyword yscriptShellCmd contained sed awk grep cat ls cd echo mkdir rm chmod chown
syn keyword yscriptShellCmd contained tar gzip unzip xxd hexdump base64 openssl
syn keyword yscriptShellCmd contained iptables netstat ss ifconfig ip nslookup dig host
syn keyword yscriptShellCmd contained traceroute whois hydra sqlmap gobuster dirb nikto wpscan
syn keyword yscriptShellCmd contained powershell cmd reg systeminfo hostname ipconfig arp route tracert
syn keyword yscriptShellCmd contained jq timeout find xargs tee sort uniq wc head tail
syn keyword yscriptShellCmd contained strings objdump readelf ltrace strace tcpdump
syn keyword yscriptShellCmd contained metasploit msfconsole msfvenom searchsploit
syn keyword yscriptShellCmd contained john hashcat aircrack aircrack-ng reaver bettercap responder

hi def yscriptShellCmd      ctermfg=6   guifg=#44bbdd

" ── 字符串 ────────────────────────────────────────────

" 插值字符串 $"..."（Go: readInterpString，TOKEN_INTERP_START）
syn region yscriptInterpString start=+\$"+ end=+"+ keepend contains=yscriptEscape,yscriptInterpEscape,yscriptInterpPrefix,yscriptInterpVar
syn match  yscriptInterpPrefix "\$" contained
syn match  yscriptInterpVar    "\${[^}]*}" contained
syn match  yscriptInterpEscape "\\\$" contained

syn region yscriptString     start=+"+ end=+"+ skip=+\\\\\|\\"+ contains=yscriptEscape,yscriptInterpolation
syn region yscriptBytes      start=+b"+ end=+"+ skip=+\\\\\|\\"+ contains=yscriptEscape,yscriptBytesPrefix

" bytes 的 base64 前缀: b"base64:SGVsbG8="
" 注意：不能用 \b（当前环境 \b 不匹配）；用非标识符前置断言
syn match  yscriptBytesPrefix "[A-Za-z0-9_]\@<!base64:" contained

" 字符串插值 {var}（doc 写法: "http://{host}:8080"）
syn match  yscriptInterpolation "{[^}]*}" contained

" 转义序列
syn match  yscriptEscape     "\\[abfnrtv\\\"'?0]" contained
syn match  yscriptEscape     "\\x[0-9a-fA-F]\{1,2}" contained
syn match  yscriptEscape     "\\u[0-9a-fA-F]\{4}" contained
syn match  yscriptEscape     "\\U[0-9a-fA-F]\{8}" contained

" ── 数字 ──────────────────────────────────────────────
" 注意：Int 必须先定义；同一位置多个 match 时最后定义者优先，
" 否则 Float/Hex/Oct/Bin 会被 Int 吃掉前缀（3.14 → 3 + . + 14）
syn match  yscriptInt        "\<\d\+\>"
syn match  yscriptFloat      "\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=\>"
syn match  yscriptFloat      "\<\d\+[eE][+-]\=\d\+\>"
syn match  yscriptHex        "\<0[xX][0-9a-fA-F]\+\>"
syn match  yscriptOct        "\<0[oO][0-7]\+\>"
syn match  yscriptBin        "\<0[bB][01]\+\>"

" ── 内置函数 ──────────────────────────────────────

" 基础 I/O
syn keyword yscriptBuiltin    print println printf sprintf

" 类型转换（定义在类型之前：同词时后定义的类型关键字优先）
syn keyword yscriptBuiltin    string int float bool byte hex char

" 元编程
syn keyword yscriptBuiltin    len type eval next

" IP 构造
syn keyword yscriptBuiltin    ipv4 ipv6

" ── 关键字全（按分类）──────────────────────────────

" 程序结构
syn keyword yscriptStatement  package import as using namespace

" 变量与常量
syn keyword yscriptStatement  let const var

" 函数定义
syn keyword yscriptStatement  func return defer yield init main

" 类型定义
syn keyword yscriptStatement  struct enum interface class map do warp this self

" 流程控制
syn keyword yscriptConditional if else elif switch case default match
syn keyword yscriptRepeat      for while loop in range break continue goto

" 异常处理
syn keyword yscriptException  try catch finally raise panic recover assert

" 比较/匹配关键字
syn keyword yscriptComparison matches is

" 逻辑运算
syn keyword yscriptBoolean    true false
syn keyword yscriptLogical    and or not xor

" 特殊值
syn keyword yscriptSpecial    nil nan inf

" ── 类型 ──────────────────────────────────────────────
syn keyword yscriptType       byte char short ushort int uint long ulong
syn keyword yscriptType       float double bool string bytes list dict
syn keyword yscriptType       ipv4 ipv6 error void any command

" ── 命名空间 ────────────────────────────────────
" 用 match 而非 keyword，便于与命名空间函数/常量匹配共存
syn match   yscriptNamespace  "\<\%(io\|net\|http\|ssl\|raw\|json\|regex\|binary\|encoding\|crypto\|aes\|rsa\|compress\|yaml\|toml\|ini\|sync\|time\|rand\|sys\|os\|path\|strings\|array\|from\|log\|stdio\|color\|ffi\|reflect\|errors\|cuda\|url\|iter\|csv\|xml\|thread\)\>"

" 命名空间函数调用 ns.func（ns 部分青色，函数名亮蓝）
syn match   yscriptQualifiedBuiltin "\<\%(io\|net\|http\|ssl\|raw\|json\|regex\|binary\|encoding\|crypto\|aes\|rsa\|compress\|yaml\|toml\|ini\|sync\|time\|rand\|sys\|os\|path\|strings\|array\|from\|log\|stdio\|color\|ffi\|reflect\|errors\|cuda\|url\|iter\|csv\|xml\|thread\)\.[A-Za-z_][A-Za-z0-9_]*" contains=yscriptNsDot
syn match   yscriptNsDot       "\<\%(io\|net\|http\|ssl\|raw\|json\|regex\|binary\|encoding\|crypto\|aes\|rsa\|compress\|yaml\|toml\|ini\|sync\|time\|rand\|sys\|os\|path\|strings\|array\|from\|log\|stdio\|color\|ffi\|reflect\|errors\|cuda\|url\|iter\|csv\|xml\|thread\)\." contained

" 命名空间常量 io.Stdin / io.EOF / time.DAY / binary.EOF
" 定义在命名空间函数之后，同位置优先（最后定义者胜）
syn match   yscriptConstant    "\<\%(time\.\(DAY\|HOUR\|MINUTE\|SECOND\|MILLISECOND\|RFC3339\)\|binary\.EOF\|io\.\(EOF\|Stdin\|Stdout\|Stderr\)\)\>"

" ── 函数/类型声明名称 ───────────────────────────
" 锚定在名字本身（func/struct 关键字会压制以其为起点的 match）
syn match   yscriptFuncName    "\%(\<func\s\+\%(this\.\)\?\)\@<=[A-Za-z_][A-Za-z0-9_]*"
syn match   yscriptTypeName    "\%(\<\%(struct\|interface\|enum\|class\)\s\+\)\@<=[A-Za-z_][A-Za-z0-9_]*"

" ── 标签 label: ─────────────────────────────────
syn match   yscriptLabel       "^[ \t]*\zs[A-Za-z_][A-Za-z0-9_]*\ze:[ \t]*$"

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

" 通道/箭头（<- 定义在 < 之后，同位置优先）
syn match  yscriptOperator    "<-"

" 位运算
syn match  yscriptOperator    "[&|^~]"

" 算术
syn match  yscriptOperator    "[+\-*/%]"

" 空安全 / 成员 / 指针
syn match  yscriptOperator    "?\.\|??"
syn match  yscriptOperator    "?"
syn match  yscriptOperator    "\.\|::"
syn match  yscriptOperator    "@>"
syn match  yscriptOperator    "@"

" 箭头 / match 分支 / 范围
syn match  yscriptOperator    "->"
syn match  yscriptOperator    "=>"
syn match  yscriptOperator    "\.\.\|\.\.\."

" Test 表达式: -e -f -d -r -w -x -s -L -h -b -c -p -S -u -g -k
" -nt -ot -ef -z -n -a -o -eq -ne -gt -lt -ge -le --readonly --system --archive
syn match  yscriptTestOp      "[A-Za-z0-9_]\@<!-\(nt\|ot\|ef\|eq\|ne\|gt\|lt\|ge\|le\|e\|f\|d\|r\|w\|x\|s\|L\|h\|b\|c\|p\|S\|u\|g\|k\|z\|n\|a\|o\)\>"
syn match  yscriptTestOp      "--[A-Za-z_][A-Za-z0-9_-]*"

" ── 分隔符 ────────────────────────────────────────────
syn match  yscriptDelimiter   "[{}()\[\];,:]"

" ── 方法 / 属性（点号后；定义在操作符后，优先于 . 操作符）──
syn match   yscriptMethod      "[^?]\@<=\.\zs[A-Za-z_][A-Za-z0-9_]*"

" ── 正则字面量 /pattern/flags（定义在操作符后，优先于 / 除号）──
" 首字符 guard: 不是 / 或 *（避免 // 与 /* 被当成正则）
syn match   yscriptRegexp      "^[ \t]*\zs/\%([/*]\)\@![^/\\]*\%(\\.[^/\\]*\)*/[imsU]*"
syn match   yscriptRegexp      "\%([A-Za-z0-9_)\]'\":.]\|[A-Za-z0-9_)\]'\":.]\s\)\@<!/\%([/*]\)\@![^/\\]*\%(\\.[^/\\]*\)*/[imsU]*"

" ── 全局常量 ─────────────────────────────────────
syn keyword yscriptConstant   LAST_EXIT_CODE __FILE__ __LINE__ __FUNC__ OS ARCH VERSION ENV
syn keyword yscriptConstant   ErrOK ErrGeneral ErrTimeout ErrCanceled ErrPermission ErrNotFound ErrExists ErrInvalidArg ErrNotSupported
syn keyword yscriptConstant   ErrNetGeneral ErrNetTimeout ErrNetRefused ErrNetUnreach ErrNetReset ErrNetDNS ErrNetTLS
syn keyword yscriptConstant   ErrIOGeneral ErrIORead ErrIOWrite ErrIOEOF ErrIODiskFull ErrIOPermission

" ── 高亮定义 ──────────────────────────────

" 关键字 (声明/控制流) → 黄色
hi def yscriptStatement       ctermfg=11  guifg=#ffcc00
hi def yscriptConditional     ctermfg=11  guifg=#ffcc00
hi def yscriptRepeat          ctermfg=11  guifg=#ffcc00
hi def yscriptException       ctermfg=11  guifg=#ffcc00
hi def yscriptComparison      ctermfg=11  guifg=#ffcc00

" 预处理器 → 橙色
hi def yscriptPreproc         ctermfg=214 guifg=#ffaa44

" 类型 → 紫色
hi def yscriptType            ctermfg=13  guifg=#cc88ff

" 类型声明名称 → 浅紫
hi def yscriptTypeName        ctermfg=141 guifg=#af87ff

" 内置函数 → 亮蓝
hi def yscriptBuiltin         ctermfg=12  guifg=#6699ff
hi def yscriptQualifiedBuiltin ctermfg=12 guifg=#6699ff

" 函数名 → 亮蓝
hi def yscriptFuncName        ctermfg=81  guifg=#66d9ff

" 命名空间 → 青色
hi def yscriptNamespace       ctermfg=6   guifg=#66cccc
hi def yscriptNsDot           ctermfg=6   guifg=#66cccc

" 方法/属性 → 青绿
hi def yscriptMethod          ctermfg=79  guifg=#5fd7af

" 逻辑关键字 → 亮黄
hi def yscriptLogical         ctermfg=228 guifg=#ffff87

" 布尔/特殊常量 → 亮青
hi def yscriptBoolean         ctermfg=14  guifg=#66ccff
hi def yscriptSpecial         ctermfg=14  guifg=#66ccff
hi def yscriptConstant        ctermfg=14  guifg=#66ccff

" 字符串/bytes/Shell/插值字符串/正则 → 绿色
hi def yscriptString          ctermfg=10  guifg=#66ff66
hi def yscriptBytes           ctermfg=10  guifg=#66ff66
hi def yscriptShellCommand    ctermfg=10  guifg=#66ff66
hi def yscriptInterpString    ctermfg=10  guifg=#66ff66
hi def yscriptRegexp          ctermfg=10  guifg=#66ff66

" 字符串插值 → 亮绿
hi def yscriptInterpolation   ctermfg=120 guifg=#88ff88
hi def yscriptInterpVar       ctermfg=120 guifg=#88ff88

" 插值/bytes 前缀 → 黄色
hi def yscriptInterpPrefix    ctermfg=11  guifg=#ffcc00
hi def yscriptBytesPrefix     ctermfg=11  guifg=#ffcc00

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

" 标签 → 亮黄
hi def yscriptLabel           ctermfg=228 guifg=#ffff87

" Shell 变量 → 青色
hi def yscriptShellVar        ctermfg=6   guifg=#44bbdd

" Shell 函数 → 青色
hi def yscriptShellFunc       ctermfg=6   guifg=#44bbdd

" 转义序列 → 亮红
hi def yscriptEscape          ctermfg=9   guifg=#ff6666
hi def yscriptInterpEscape    ctermfg=9   guifg=#ff6666
hi def yscriptShellEscape     ctermfg=9   guifg=#ff6666

let b:current_syntax = "yscript"
