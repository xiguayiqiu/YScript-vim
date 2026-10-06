" YScript Vim syntax highlighting
" Full syntax support for YScript InfoSec scripting language
" Last updated: 2026-10（Unicode 字符串方法与严格数值转换）
"
" 语法范围对照 YScript Go 词法器 (yscript/internal/lexer) 与 doc/ 文档：
"   - 关键字 var/using/namespace/do/class/map/matches/is
"     try/catch/finally/ensure/raise/self
"   - 预处理器指令 #if/#elif/#else/#endif/#!permit (internal/preproc)
"   - 插值字符串 $"..." 与 ${expr}（TOKEN_INTERP_START）
"   - bytes 的 base64 前缀 b"base64:..."
"   - 正则字面量 /pattern/flags（TOKEN_REGEXP）
"   - 标签 label:（TOKEN_LABEL）
"   - 命名空间函数 socket.Socket、命名空间常量 io.Stdin / time.DAY
"   - Err* 错误码常量（doc/18）
"
" 命名空间清单与 internal/std 的 GetNamespace() 保持一致（38 个）。

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
syn keyword yscriptStatement  struct enum interface class map do warp this self super
syn keyword yscriptStatement  extends

" 流程控制
syn keyword yscriptConditional if else elif switch case default match
syn keyword yscriptRepeat      for while loop in range break continue goto

" 异常处理
syn keyword yscriptException  try catch finally ensure raise panic recover assert

" 比较/匹配关键字
syn keyword yscriptComparison matches is

" 逻辑运算
syn keyword yscriptBoolean    true false
syn keyword yscriptLogical    and or not xor

" 特殊值
syn keyword yscriptSpecial    nil null nan inf

" ── 类型 ──────────────────────────────────────────────
syn keyword yscriptType       byte char short ushort int uint long ulong
syn keyword yscriptType       float double bool string bytes list dict
syn keyword yscriptType       ipv4 ipv6 error void any command
" FFI/C 互操作的类型名（clong/culong 是 C 的 long，宽度随平台而变）
syn keyword yscriptType       clong culong ptr void cstring

" ── 命名空间 ────────────────────────────────────
" 用 match 而非 keyword，便于与命名空间函数/常量匹配共存
syn match   yscriptNamespace  "\<\%(aes\|array\|binary\|c\|color\|compress\|crypto\|csv\|cuda\|encoding\|errors\|ffi\|from\|http\|ini\|io\|iter\|json\|log\|net\|os\|path\|rand\|raw\|reflect\|regex\|rsa\|socket\|ssl\|stdio\|string\|strings\|sync\|sys\|thread\|time\|toml\|url\|xml\|yaml\)\>"

" 命名空间函数调用 ns.func（ns 部分青色，函数名亮蓝）
syn match   yscriptQualifiedBuiltin "\<\%(aes\|array\|binary\|c\|color\|compress\|crypto\|csv\|cuda\|encoding\|errors\|ffi\|from\|http\|ini\|io\|iter\|json\|log\|net\|os\|path\|rand\|raw\|reflect\|regex\|rsa\|socket\|ssl\|stdio\|string\|strings\|sync\|sys\|thread\|time\|toml\|url\|xml\|yaml\)\>\.[A-Za-z_][A-Za-z0-9_]*" contains=yscriptNsDot
syn match   yscriptNsDot       "\<\%(aes\|array\|binary\|c\|color\|compress\|crypto\|csv\|cuda\|encoding\|errors\|ffi\|from\|http\|ini\|io\|iter\|json\|log\|net\|os\|path\|rand\|raw\|reflect\|regex\|rsa\|socket\|ssl\|stdio\|string\|strings\|sync\|sys\|thread\|time\|toml\|url\|xml\|yaml\)\>\." contained

" 命名空间常量 io.Stdin / io.EOF / time.DAY / binary.EOF
" 定义在命名空间函数之后，同位置优先（最后定义者胜）
syn match   yscriptConstant    "\<\%(time\.\(DAY\|HOUR\|MINUTE\|SECOND\|MILLISECOND\|RFC3339\)\|binary\.EOF\|io\.\(EOF\|Stdin\|Stdout\|Stderr\)\)\>"

" ── HTTP 高频成员（v0.1.5.1：Server / StatusCode / 退避策略 / 钩子）──
" 方法动词 + 状态码/退避/服务端额外突出，让 http.* 调用一眼可读
syn match   yscriptHttpFunc    "http\.\%(Get\|Post\|Put\|Patch\|Delete\|Head\|Options\|Do\|Request\)\>"
syn match   yscriptHttpFunc    "http\.\%(Server\|Session\|Form\|Upload\|Download\|Dump\|Query\)\>"
syn match   yscriptHttpFunc    "http\.\%(Headers\|Body\|Raw\|Json\|Ok\|Cookie\|Cookies\|StatusText\|StatusCode\)\>"
syn match   yscriptHttpFunc    "http\.\%(Set\%(Timeout\|Proxy\|UserAgent\|Header\|Redirects\|Cookie\|Retries\|RetryDelay\|RetryBackoff\|MaxBody\|Raise\|AfterResponse\)\|BasicAuth\|Insecure\|Clear\%(Cookies\|Headers\)\|LastError\|Reset\)\>"

" 静态目录 / PHP CGI 服务
syn match   yscriptNetFunc     "net\.\%(nginx\|Nginx\)\>"

" 加密与哈希：SHA2/SHA3/BLAKE2/HMAC
syn match   yscriptCryptoFunc  "crypto\.\%(MD5\|SHA1\|SHA224\|SHA256\|SHA384\|SHA512\|SHA512_224\|SHA512_256\|SHA3_224\|SHA3_256\|SHA3_384\|SHA3_512\|SHAKE128\|SHAKE256\|BLAKE2s\|BLAKE2b\|HMAC_SHA256\|HMAC_SHA3\|HMAC_SHA3_256\|HMAC_SHA3_384\|HMAC_SHA3_512\|HMAC_SHA512\|HashFile\|PBKDF2\|BcryptHash\|BcryptVerify\)\>"

" ── C/FFI 高频成员 ─────────────────────────────────────
" c 模块：编译工具链 + 动态库 + 回调 + 头文件解析
syn match   yscriptCFunc      "c\.\%(compile\|compile_load\|compile_obj\|link\|load\|unload\|bind\|find\|call\)\>"
syn match   yscriptCFunc      "c\.\%(callback\|callback_free\|parse_header\|header_bind\)\>"
syn match   yscriptCFunc      "c\.\%(compiler\|compilers\)\>"
" ffi 命名空间
syn match   yscriptCFunc      "ffi\.\%(open\|find\|bind\|call\|alloc\|free\|read\|write\|str\)\>"
" 回调类型标记：c.callback(...) 的参数里会出现这些 FFI 类型名
" 结构体类型形如 struct:int32,double（冒号后是字段类型列表）
syn match   yscriptFFIType    "\<\%(clong\|culong\|int8\|int16\|int32\|int64\)\>"
syn match   yscriptFFIType    "\<struct\ze\:[A-Za-z0-9_,]\+\>"

" ── 函数/类型声明名称 ───────────────────────────
" 锚定在名字本身（func/struct 关键字会压制以其为起点的 match）
syn match   yscriptFuncName    "\%(\<func\s\+\%(this\.\)\?\)\@<=[A-Za-z_][A-Za-z0-9_]*"
syn match   yscriptTypeName    "\%(\<\%(struct\|interface\|enum\|class\)\s\+\)\@<=[A-Za-z_][A-Za-z0-9_]*"
syn match   yscriptTypeName    "\%(\<extends\s\+\)\@<=[A-Za-z_][A-Za-z0-9_]*"

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
" 注意：. 后紧跟标识符时交给 yscriptMethod（成员名），
" 否则 . 会被此处的 operator 抢先匹配（同位置同时定义时 operator 胜出），
" 导致 s.listen / "x".upper() 等方法名完全不高亮。
syn match  yscriptOperator    "?\.\|??"
syn match  yscriptOperator    "?"
syn match  yscriptOperator    "\.\%(\%(_\|[A-Za-z]\)\)\@!\|::"
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
syn match   yscriptStringMethod "\.\zs\%(rune_len\|char_at\|slice\|to_int\|to_float\)\>"

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

" C/FFI 成员：比普通命名空间函数略深，呼应「外部函数」语义
hi def link yscriptCFunc       yscriptQualifiedBuiltin
hi def link yscriptHttpFunc     yscriptQualifiedBuiltin
hi def link yscriptNetFunc      yscriptQualifiedBuiltin
hi def link yscriptCryptoFunc   yscriptQualifiedBuiltin
hi def yscriptFFIType         ctermfg=10  guifg=#cc9966
hi def yscriptNsDot           ctermfg=6   guifg=#66cccc

" 方法/属性 → 青绿
hi def yscriptMethod          ctermfg=79  guifg=#5fd7af
hi def link yscriptStringMethod yscriptMethod

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
