# YScript Vim 支持

<<<<<<< HEAD
YScript 语言的 Vim/Neovim 语法高亮 + 保存时自动语法检查。

**零依赖** — 无需 Node.js，无需 LSP 服务端，纯 Vimscript。

=======
YScript 语言的 Vim/Neovim 语法高亮与文件类型检测。

**零依赖** — 无需 Node.js，无需 LSP 服务端，纯 Vimscript。

兼容 YScript `v0.1.5.3`。泛型函数和结构体、类型参数、`number` / `Named` 等约束，以及 `list<T>`、`dict<K, V>` 等泛型类型均有 Vim 语法高亮。`ysc.models` / `ysc.sum` 自动识别为 `yscmanifest` 并高亮项目版本、依赖版本、Git URL 和 `h1:` 校验值。泛型错误仍由解释器在 `yscript -c` 编译检查时报告。

YScript `v0.1.5.3` 的 `load` 标准库支持模块生命周期接口，所有生命周期方法都接收源文件路径字符串：`load.install(path)` 解析、编译并注册模块但不执行代码；`load.start(path)` 执行已安装模块的初始化和顶层代码；`load.stop(path)` 调用模块可选的模块级 `stop()` 函数；`load.uninstall(path)` 必要时先停止，再移除模块声明。既有 `load.load(path)`、`load.reload(path)`、`load.unload(path)` 和 `load.loaded()` 热加载接口仍然保留。Vim 支持仅提供语法高亮，不提供这些接口的补全或执行。

`ysc doc` 支持把函数文档放在源文件任意位置，并按函数名匹配 `@functionName HEAD` 与 `@functionName END` 之间的注释。Vim 语法文件会高亮这两种标记。

>>>>>>> c853ae8 (update vim 0.1.5.3)
---

## 安装

### Vim

```bash
<<<<<<< HEAD
mkdir -p ~/.vim/{syntax,ftdetect,plugin,indent,ftplugin}
cp vim/syntax/yscript.vim ~/.vim/syntax/
cp vim/ftdetect/yscript.vim ~/.vim/ftdetect/
cp vim/plugin/yscript.vim ~/.vim/plugin/
cp vim/indent/yscript.vim ~/.vim/indent/
cp vim/ftplugin/yscript.vim ~/.vim/ftplugin/
=======
mkdir -p ~/.vim/{syntax,ftdetect}
cp vim/syntax/yscript.vim ~/.vim/syntax/
cp vim/ftdetect/yscript.vim ~/.vim/ftdetect/
>>>>>>> c853ae8 (update vim 0.1.5.3)
```

### Neovim

```bash
<<<<<<< HEAD
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

=======
mkdir -p ~/.config/nvim/{syntax,ftdetect}
cp vim/syntax/yscript.vim ~/.config/nvim/syntax/
cp vim/ftdetect/yscript.vim ~/.config/nvim/ftdetect/
```

> 需要在 `.vimrc` / `init.lua` 中启用文件类型检测：
>
> ```vim
> filetype on
> ```

## 泛型支持

语法文件会高亮泛型函数/结构体声明中的类型参数与约束名，并为泛型类型标注和实例化中的类型提供类型高亮。支持的形式包括多个类型参数、内建约束、接口约束及嵌套容器类型：

```yscript
func add<T: number>(left: T, right: T) -> T {
    return left + right
}

func display<T: Named>(value: T) -> string {
    return value.name()
}

struct Pair<K, V> {
    keys: list<K>
    values: dict<K, V>
}
```

Vim 高亮只负责编辑器显示；要检查泛型类型及约束是否有效，请手动运行 `yscript -c path/to/file.ys`。

>>>>>>> c853ae8 (update vim 0.1.5.3)
---

## 语法高亮

### 覆盖的元素

| 类别 | 高亮组 | 示例 |
|------|--------|------|
<<<<<<< HEAD
| 声明/控制流 | `yscriptStatement/Conditional/Repeat` | `func` `let` `if` `for` `warp` |
| 类型推断声明名 | `yscriptVariableName` | `result <- expression` |
| 异常 | `yscriptException` | `try` `catch` `finally` `ensure` `raise` `panic` `recover` `assert` |
| 比较/匹配 | `yscriptComparison` | `matches` `is` |
| 类型 | `yscriptType` | `string` `bytes` `list` `dict` `ipv4` `ipv6` `error` `any` |
| 内置函数 | `yscriptBuiltin` | `print` `len` `type` `eval` `hex` |
| 命名空间函数 | `yscriptQualifiedBuiltin` | `io.read_file` `json.parse` `http.Session` `ocr.recognize` |
| 函数声明名 | `yscriptFuncName` | `func main(` `func this.area(` |
| 类型声明名 | `yscriptTypeName` | `struct Point` `enum Status` `interface Scanner` |
| 命名空间 | `yscriptNamespace` | `io` `net` `json` `crypto` `ocr` `sync` `ssl` |
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
| 操作符 | `yscriptOperator` | `<-`（类型推断声明） `|>` `=>` `->` `?`(三元) `==` `?.` `??` `+=` |
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
> 与 `try`/`catch`/`finally`/`ensure`/`raise`，以及插值字符串、bytes base64 前缀、正则字面量、
> 标签、函数/类型声明名、命名空间函数与常量、`Err*` 错误码等。
>
> **命名空间**：共 **41 个**，与 `internal/std` 的 `GetNamespace()` 一致，包含
> `socket`（v0.1.4 新增的 TCP/UDP/TLS 统一对象）。
>
> **`ns.func` 通配**：命名空间成员按 `名字.标识符` 整体着色，因此
> `http.Session` / `http.Form` / `http.Upload` / `http.Download` 等
> v0.1.5.1 新增的 HTTP 成员自动高亮，无需手工维护成员清单。
>
> **成员名高亮**：`.` 后紧跟标识符时按方法/属性着色（`s.listen()`、`"x".upper()`、
> `m.try_lock()`），此时 `.` 本身不再按操作符着色；浮点字面量（`1.5`）不受影响。
=======
| 声明/控制流 | `yscriptStatement` | `func` `let` `if` `for` `struct` |
| 异常 | `yscriptException` | `try` `catch` `raise` `panic` `recover` |
| 类型 | `yscriptType` | `string` `bytes` `list` `dict` `ipv4` `T` `Box` |
| 泛型参数列表/约束 | `yscriptGenericParams/Constraint` | `func identity<T>` `func add<T: number>` `func display<T: Named>` |
| 函数/类型声明名 | `yscriptFuncName/TypeName` | `func main(` `struct Box<T>` |
| 内置函数 | `yscriptBuiltin` | `print` `len` `type` `eval` `hex` |
| 逻辑 | `yscriptLogical` | `and` `or` `not` `xor` |
| 布尔/特殊值 | `yscriptSpecial` | `true` `false` `nil` |
| 字符串 | `yscriptString` | `"hello world"` |
| 注释 | `yscriptComment/yscriptBlockComment` | `# 行注释` `#* 块注释 *#` |
| 文档注解标记 | `yscriptDocAnnotation` | `@banner_text HEAD` `@banner_text END` |
| 数字 | `yscriptNumber` | `42` `3.14` |
| 操作符 | `yscriptOperator` | `<-` `=>` `->` `==` `?.` `??` `+=` |

各组默认链接到 Vim 的标准高亮组，颜色由当前 colorscheme 决定。

> 类型参数和内建约束沿用类型高亮，自定义约束名使用 `yscriptGenericConstraint` 组；嵌套类型注解与实例化中的类型沿用类型高亮。Vim 不执行类型检查。
>>>>>>> c853ae8 (update vim 0.1.5.3)

---

## 文件类型检测

<<<<<<< HEAD
自动为 `.ys` 和 `.yscript` 文件启用 YScript 文件类型。

---

## 插件功能

**语法高亮** — 覆盖全部关键字（70 个）、41 个内置命名空间、
C/FFI 互操作（`c.compile` / `c.callback` / `c.parse_header` / `ffi.alloc` 等成员，
以及 `struct:int32,double`、`clong`/`culong` 等类型写法）。

**保存时语法检查** — 保存文件时自动运行 `yscript -c <file>`，语法错误显示在消息栏。

如需禁用：

```vim
let g:loaded_yscript_plugin = 1
```
=======
自动为 `.ys` 和 `.yscript` 文件启用 YScript 文件类型；自动为 `ysc.models` 和 `ysc.sum` 启用依赖清单高亮。

---

## 支持范围

此目录提供 YScript 语法高亮和 `.ys` / `.yscript` 文件类型检测。语法检查、自动缩进和 LSP 补全不由这些 Vim 文件提供。
>>>>>>> c853ae8 (update vim 0.1.5.3)

---

## 快捷键建议

在 `.vimrc` 中添加：

```vim
autocmd FileType yscript nnoremap <buffer> <F5> :!yscript %<CR>
autocmd FileType yscript nnoremap <buffer> <F6> :!yscript -c %<CR>
```
