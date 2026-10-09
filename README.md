# YScript Vim 支持

此目录提供 YScript 的 Vim/Neovim 语法高亮、文件类型检测、缩进和可选的
`ysc -c` 语法检查，不依赖 Node.js 或 LSP 服务端。

## 安装

将仓库中的 Vim 文件复制到 Vim 配置目录：

```sh
mkdir -p ~/.vim/{syntax,ftdetect,plugin,indent,ftplugin}
cp vim/syntax/*.vim ~/.vim/syntax/
cp vim/ftdetect/*.vim ~/.vim/ftdetect/
cp vim/plugin/*.vim ~/.vim/plugin/
cp vim/indent/*.vim ~/.vim/indent/
cp vim/ftplugin/*.vim ~/.vim/ftplugin/
```

Neovim 用户将 `~/.vim` 替换为 `~/.config/nvim`。在 `.vimrc` 或
`init.lua` 中启用文件类型、插件和缩进：

```vim
filetype plugin indent on
syntax on
```

## 语法支持

`syntax/yscript.vim` 跟进当前 YScript 词法器，覆盖：

- 声明和流程控制、异常处理、`matches` / `is`、逻辑运算和特殊值；
- 基础类型、FFI 类型、泛型函数/结构体参数与约束、类型推断声明
  （`name <- expression`）；
- 文档注解块（`@functionName HEAD` / `@functionName END`）；
- 字符串、插值字符串、bytes/base64、正则、反引号 Shell 命令、数字和转义；
- 预处理指令、标签、测试表达式操作符、内置函数和标准库命名空间成员。

示例：

```yscript
@identity HEAD
# 返回输入值。
@identity END
func identity<T: number>(value: T) -> T {
    return value
}

result <- identity(42)
```

`.ys` / `.yscript` 自动识别为 YScript；`ysc.models` / `ysc.sum` 自动识别为
依赖清单，并使用 `yscmanifest` 语法高亮。

## 缩进与编辑

`indent/yscript.vim` 和 `ftplugin/yscript.vim` 提供 4 空格缩进、括号/代码块
续行缩进、`case` / `default` / `else` / `elif` 对齐，以及 `#` 注释续行。

## 可选语法检查

将 `ysc` 放入 `PATH` 后，可在 Vim 中运行 `:YscriptCheck`（默认映射 `<F6>`）。
保存时自动检查默认关闭；可在 `.vimrc` 中显式启用：

```vim
let g:yscript_check_on_save = 1
```

也可以指定可执行文件路径，并关闭默认快捷键：

```vim
let g:yscript_executable = '/path/to/ysc'
let g:yscript_keymap = ''
```

错误会写入 quickfix 列表。此功能调用 `ysc -c <file>`；语法文件本身只负责
高亮，不执行脚本，也不提供 LSP 补全。

## 动态模块

YScript `load` 标准库支持 `load.install(path)`、`load.start(path)`、
`load.stop(path)` 和 `load.uninstall(path)` 模块生命周期接口，同时保留
`load.load` / `load.reload` / `load.unload` / `load.loaded` 函数插件 API。
Vim 插件不执行这些接口，仅提供相应代码的语法高亮。
