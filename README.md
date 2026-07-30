YScript Vim 支持
================

YScript 语言的 Vim 语法高亮 + 保存时自动语法检查。

无需 Node.js，无需 LSP 服务端，零依赖。

目录
----

| 路径               | 说明                     |
|--------------------|--------------------------|
| `syntax/`          | 语法高亮定义             |
| `ftdetect/`        | 文件类型自动检测 (.ys)   |
| `plugin/`          | 保存时语法检查插件       |

安装
----

### 1. 复制文件

```bash
# Linux/macOS
mkdir -p ~/.vim/{syntax,ftdetect,plugin}
cp vim/syntax/yscript.vim ~/.vim/syntax/
cp vim/ftdetect/yscript.vim ~/.vim/ftdetect/
cp vim/plugin/yscript.vim ~/.vim/plugin/

# Neovim
mkdir -p ~/.config/nvim/{syntax,ftdetect,plugin}
cp vim/syntax/yscript.vim ~/.config/nvim/syntax/
cp vim/ftdetect/yscript.vim ~/.config/nvim/ftdetect/
cp vim/plugin/yscript.vim ~/.config/nvim/plugin/
```

### 2. 编译 yscript（可选，启用保存时语法检查）

```bash
cd path/to/yscript
go build -o yscript ./cmd/yscript/
sudo cp yscript /usr/local/bin/
```

保存 `.ys` 文件时会自动调用 `yscript -c` 检查语法，
错误信息显示在 Vim 消息栏。

语法高亮
--------

| 元素             | 高亮组            |
|------------------|-------------------|
| 关键字           | Keyword           |
| 类型             | Type              |
| 字符串           | String            |
| 数字             | Number            |
| 常量             | Boolean/Special   |
| 注释             | Comment           |
| 操作符           | Operator          |
| Shell 命令       | String            |
| 函数调用         | Function          |
