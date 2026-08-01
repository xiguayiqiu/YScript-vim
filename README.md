# YScript Vim 支持

YScript 语言的 Vim/Neovim 语法高亮 + 保存时自动语法检查。

**零依赖** — 无需 Node.js，无需 LSP 服务端，纯 Vimscript。

---

## 安装

### Vim

```bash
mkdir -p ~/.vim/{syntax,ftdetect,plugin}
cp vim/syntax/yscript.vim ~/.vim/syntax/
cp vim/ftdetect/yscript.vim ~/.vim/ftdetect/
cp vim/plugin/yscript.vim ~/.vim/plugin/
```

### Neovim

```bash
mkdir -p ~/.config/nvim/{syntax,ftdetect,plugin}
cp vim/syntax/yscript.vim ~/.config/nvim/syntax/
cp vim/ftdetect/yscript.vim ~/.config/nvim/ftdetect/
cp vim/plugin/yscript.vim ~/.config/nvim/plugin/
```

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
| 异常 | `yscriptException` | `panic` `recover` `assert` `defer` |
| 类型 | `yscriptType` | `string` `bytes` `list` `dict` `ipv4` `ipv6` |
| 内置函数 | `yscriptBuiltin` | `print` `len` `type` `eval` `hex` |
| 命名空间 | `yscriptNamespace` | `io` `net` `json` `crypto` `sync` `ssl` |
| 逻辑 | `yscriptLogical` | `and` `or` `not` `xor` |
| 常量/特殊值 | `yscriptBoolean/Special/Constant` | `true` `false` `nil` `LAST_EXIT_CODE` `OS` `ENV` |
| 字符串 | `yscriptString` | `"hello world"` |
| 字符串插值 | `yscriptInterpolation` | `"port: {port}"` |
| 字节字面量 | `yscriptBytes` | `b"\x90\x90\xcc"` |
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
| 类型 | 紫色 `#cc88ff` |
| 内置函数 | 亮蓝 `#6699ff` |
| 字符串/Shell/Bytes | 绿色 `#66ff66` |
| 数字 | 亮紫 `#ff87ff` |
| 注释 | 灰色 `#888888` |
| Shell 命令名 | 青色 `#44bbdd` |
| 常量/布尔/nil | 亮青 `#66ccff` |
| 转义序列 | 亮红 `#ff6666` |

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
