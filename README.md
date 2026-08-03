# YScript Vim 支持

YScript 语言的 Vim/Neovim 语法高亮 + 保存时自动语法检查。

**零依赖** — 无需 Node.js，无需 LSP 服务端，纯 Vimscript。

---

## 安装

### Vim

```bash
mkdir -p ~/.vim/{syntax,ftdetect,plugin,indent,ftplugin}
cp vim/syntax/yscript.vim ~/.vim/syntax/
cp vim/ftdetect/yscript.vim ~/.vim/ftdetect/
cp vim/plugin/yscript.vim ~/.vim/plugin/
cp vim/indent/yscript.vim ~/.vim/indent/
cp vim/ftplugin/yscript.vim ~/.vim/ftplugin/
```

### Neovim

```bash
mkdir -p ~/.config/nvim/{syntax,ftdetect,plugin,indent,ftplugin}
cp vim/syntax/yscript.vim ~/.config/nvim/syntax/
cp vim/ftdetect/yscript.vim ~/.config/nvim/ftdetect/
cp vim/plugin/yscript.vim ~/.config/nvim/plugin/
cp vim/indent/yscript.vim ~/.config/nvim/indent/
cp vim/ftplugin/yscript.vim ~/.config/nvim/ftplugin/
```

> 需要在 `.vimrc` / `init.lua` 中启用插件与缩进支持：
>
> ```vim
> filetype plugin indent on
> ```

## 缩进 / Tab / 回车

插件自带 `indent/yscript.vim` 与 `ftplugin/yscript.vim`，为 `.ys` / `.yscript` 提供合理的缩进行为：

- **Tab = 4 空格**：`expandtab` + `shiftwidth=4`，插入模式下按 Tab 对齐到 4 的整数倍；
- **回车自动换行缩进**：在 `{` 或 `=>`（match 分支）行尾回车，新行自动加一层缩进；`(` 结尾自动续行缩进；
- **自动回退**：行首输入 `}` 自动与匹配的 `{` 对齐，`case` / `default` / `else` / `elif` 自动回退到对应层级；
- **预处理器指令**（`#if` / `#elif` / `#else` / `#endif` / `#!permit`）保持所在层级，不会被强制顶格；
- **注释延续**：在 `#` 注释行回车，新行自动带 `#` 前缀；
- 括号匹配忽略字符串、字节串、注释和 Shell 命令内部的 `{}` / `()`。

### 启用保存时语法检查（可选）

编译或安装 `yscript` 到 PATH 后，保存 `.ys` 文件时会自动调用 `yscript -c` 检查语法。错误信息显示在 Vim 消息栏。

```bash
cd path/to/yscript
go build -o yscript ./cmd/yscript/
sudo cp yscript /usr/local/bin/
```

---

## 语法高亮

### 覆盖的元素

| 类别 | 高亮组 | 示例 |
|------|--------|------|
| 声明/控制流 | `yscriptStatement/Conditional/Repeat` | `func` `let` `if` `for` `warp` |
| 异常 | `yscriptException` | `try` `catch` `finally` `raise` `panic` `recover` `assert` |
| 比较/匹配 | `yscriptComparison` | `matches` `is` |
| 类型 | `yscriptType` | `string` `bytes` `list` `dict` `ipv4` `ipv6` `error` `any` |
| 内置函数 | `yscriptBuiltin` | `print` `len` `type` `eval` `hex` |
| 命名空间函数 | `yscriptQualifiedBuiltin` | `io.read_file` `json.parse` `http.Get` |
| 函数声明名 | `yscriptFuncName` | `func main(` `func this.area(` |
| 类型声明名 | `yscriptTypeName` | `struct Point` `enum Status` `interface Scanner` |
| 命名空间 | `yscriptNamespace` | `io` `net` `json` `crypto` `sync` `ssl` |
| 方法/属性 | `yscriptMethod` | `s.contains()` `d.keys` `h.await()` |
| 逻辑 | `yscriptLogical` | `and` `or` `not` `xor` |
| 常量/特殊值 | `yscriptBoolean/Special/Constant` | `true` `false` `nil` `LAST_EXIT_CODE` `OS` `ENV` |
| 错误码/命名空间常量 | `yscriptConstant` | `ErrPermission` `ErrNetTimeout` `io.Stdin` `time.DAY` `binary.EOF` |
| 字符串 | `yscriptString` | `"hello world"` |
| 字符串插值 | `yscriptInterpolation` | `"port: {port}"` |
| 插值字符串 | `yscriptInterpString` | `$"port: ${port}"` |
| 字节字面量 | `yscriptBytes` | `b"\x90\x90\xcc"`、`b"base64:SGVsbG8="` |
| 正则字面量 | `yscriptRegexp` | `/ab+c/i` |
| 预处理器指令 | `yscriptPreproc` | `#if` `#elif` `#else` `#endif` `#!permit` |
| 标签 | `yscriptLabel` | `retry:` |
| Shell 命令 | `yscriptShellCommand` | `` `nmap -p 80 target` `` |
| Shell 变量 | `yscriptShellVar` | `$HOME` `$(cmd)` `${var}` |
| 数字 | `yscriptFloat/Hex/Oct/Bin/Int` | `3.14` `0xFF` `0b1010` |
| 注释 | `yscriptComment/CommentBlock` | `# 行注释` `#* 块注释 *#` |
| 操作符 | `yscriptOperator` | `|>` `=>` `->` `?`(三元) `==` `?.` `??` `+=` |
| Test 表达式 | `yscriptTestOp` | `-e` `-f` `-d` `-r` `-eq` `-gt` |
| 转义序列 | `yscriptEscape` | `\n` `\x90` `\u4f60` `\U0001F600` |

### 高亮颜色

| 元素 | 色值 |
|------|------|
| 关键字 | 黄色 `#ffcc00` |
| 预处理器 | 橙色 `#ffaa44` |
| 类型 | 紫色 `#cc88ff` |
| 类型声明名 | 浅紫 `#af87ff` |
| 内置函数 | 亮蓝 `#6699ff` |
| 函数名 | 亮蓝 `#66d9ff` |
| 方法/属性 | 青绿 `#5fd7af` |
| 字符串/Shell/Bytes | 绿色 `#66ff66` |
| 数字 | 亮紫 `#ff87ff` |
| 注释 | 灰色 `#888888` |
| Shell 命令名 | 青色 `#44bbdd` |
| 常量/布尔/nil | 亮青 `#66ccff` |
| 转义序列 | 亮红 `#ff6666` |

> 语法范围对照 YScript Go 词法器（`internal/lexer`、`internal/preproc`）与 `doc/` 文档补全：
> 新增关键字 `var` `using` `namespace` `do` `class` `map` `matches` `is` `self`
> 与 `try`/`catch`/`finally`/`raise`，以及插值字符串、bytes base64 前缀、正则字面量、
> 标签、函数/类型声明名、命名空间函数与常量、`Err*` 错误码等。

---

## 文件类型检测

自动为 `.ys` 和 `.yscript` 文件启用 YScript 文件类型。

---

## 插件功能

**保存时语法检查** — 保存文件时自动运行 `yscript -c <file>`，语法错误显示在消息栏。

如需禁用：

```vim
let g:loaded_yscript_plugin = 1
```

---

## 快捷键建议

在 `.vimrc` 中添加：

```vim
autocmd FileType yscript nnoremap <buffer> <F5> :!yscript %<CR>
autocmd FileType yscript nnoremap <buffer> <F6> :!yscript -c %<CR>
```
