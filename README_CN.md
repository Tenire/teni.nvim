# Teni.nvim

[English](README.md) | [中文](README_CN.md)

个人 Neovim 配置。专注于速度、简洁 UI 和效率。

## 🔌 插件列表

### 🎨 UI & UX (界面体验)

| 插件 | 描述 | 配置文件 |
|------|------|----------|
| **greeter** | 自定义 ASCII 启动界面 | `nvim/lua/teni/plugins/greeter.lua` |
| **icons** | `nvim-web-devicons` 图标配置 | `nvim/lua/teni/plugins/icons.lua` |
| **indent_line** | 缩进线 (`indent-blankline.nvim`) | `nvim/lua/teni/plugins/indent_line.lua` |
| **neo-tree** | 文件资源管理器 | `nvim/lua/teni/plugins/neo-tree.lua` |

### 🧠 Intelligence & Code (代码智能)

| 插件 | 描述 | 配置文件 |
|------|------|----------|
| **lsp** | 原生 LSP + Mason + Conform | `nvim/lua/teni/plugins/lsp.lua` |
| **blink.cmp** | 极速自动补全引擎 | `nvim/lua/teni/plugins/lsp.lua` |
| **lint** | 代码检查 (`nvim-lint`) | `nvim/lua/teni/plugins/lint.lua` |
| **autopairs** | 自动闭合括号/引号 | `nvim/lua/teni/plugins/autopairs.lua` |
| **ai** | AI 辅助 (如果启用) | `nvim/lua/teni/plugins/ai.lua` |

### 🛠️ Tools (工具)

| 插件 | 描述 | 配置文件 |
|------|------|----------|
| **telescope** | 模糊搜索与选择器 | `nvim/lua/teni/plugins/telescope.lua` |
| **gitsigns** | Git 信息集成 | `nvim/lua/teni/plugins/gitsigns.lua` |
| **debug** | 调试支持 (`nvim-dap`) | `nvim/lua/teni/plugins/debug.lua` |

---

## ⌨️ 快捷键速查表

### 通用

| 按键 | 动作 |
|-----|--------|
| `<Space>` | Leader 键 |
| `;` | 进入命令模式 (`:`) |
| `jk` | 退出插入模式 (`<Esc>`) |
| `<Esc>` | 清除搜索高亮 (`nohlsearch`) |
| `<leader>q` | 打开诊断 Quickfix 列表 |

### 导航与标签页

| 按键 | 动作 |
|-----|--------|
| `tn` | 新建标签页 |
| `tj` | 上一个标签页 |
| `tk` | 下一个标签页 |
| `<C-h/j/k/l>` | 窗口切换 |

### 🔍 Telescope (搜索)

| 按键 | 动作 |
|-----|--------|
| `<C-p>` / `<leader>sf` | 查找文件 |
| `<leader>sg` | 全局搜索 (Live Grep) |
| `<leader>sw` | 搜索当前光标下的词 |
| `<leader><leader>` | 查找已打开的 Buffer |
| `<leader>/` | 当前文件内模糊搜索 |
| `<leader>sh` | 搜索帮助文档 |
| `<leader>sk` | 搜索快捷键 |
| `<leader>s.` | 最近打开的文件 |

*Telescope 内部:*
- `<C-j/k>`: 上下选择
- `<C-t>`: 在新标签页打开

### 🛠️ LSP (代码智能)

| 按键 | 动作 |
|-----|--------|
| `grd` | 跳转定义 (**G**o to **D**efinition) |
| `grr` | 查找引用 (**G**o to **R**eferences) |
| `grn` | 重命名符号 (**R**e**n**ame) |
| `gra` | 代码操作 (Code **A**ctions) |
| `gO` | 文档符号列表 |
| `L` | 显示当前行诊断悬浮窗 |
| `<leader>th` | 切换内联提示 (Inlay Hints) |

### 🐛 调试 (DAP)

| 按键 | 动作 |
|-----|--------|
| `<F5>` | 启动 / 继续 |
| `<F1>` | 单步进入 (Step Into) |
| `<F2>` | 单步跳过 (Step Over) |
| `<F3>` | 单步跳出 (Step Out) |
| `<F7>` | 切换调试界面 UI |
| `<leader>b` | 切换断点 |
| `<leader>B` | 设置条件断点 |

### 📂 文件浏览器 (Neo-tree)

| 按键 | 动作 |
|-----|--------|
| `<C-e>` | 打开/关闭文件树 |

### 📝 Git (Gitsigns)

| 按键 | 动作 |
|-----|--------|
| `]c` | 下一个修改块 (Hunk) |
| `[c` | 上一个修改块 (Hunk) |
| `<leader>hs` | 暂存修改块 (Stage) |
| `<leader>hr` | 重置修改块 (Reset) |
| `<leader>hp` | 预览修改块 |
| `<leader>hb` | 显示行 Blame 信息 |
| `<leader>hd` | 当前文件 Diff |

---

## 📦 安装

```bash
# 克隆仓库
git clone https://github.com/yourusername/Teni.nvim.git ~/.config/Teni.nvim

# 安装
cd ~/.config/Teni.nvim
chmod +x install.sh
./install.sh
```

## 📄 目录结构

- `nvim/lua/teni/options.lua`: Vim 基础设置 (行号, 缩进等)
- `nvim/lua/teni/keymaps.lua`: 全局快捷键
- `nvim/lua/teni/plugins/`: 插件配置 (按功能分类)
