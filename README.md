# Teni.nvim

[English](README.md) | [中文](README_CN.md)

Personal Neovim configuration. Focused on speed, clean UI, and efficiency.

## 🔌 Plugins List

### 🎨 UI & UX

| Plugin | Description | Config File |
|--------|-------------|-------------|
| **greeter** | Custom dashboard with ASCII art | `nvim/lua/teni/plugins/greeter.lua` |
| **icons** | `nvim-web-devicons` configuration | `nvim/lua/teni/plugins/icons.lua` |
| **indent_line** | Indent guides (`indent-blankline.nvim`) | `nvim/lua/teni/plugins/indent_line.lua` |
| **neo-tree** | File explorer tree | `nvim/lua/teni/plugins/neo-tree.lua` |

### 🧠 Intelligence & Code

| Plugin | Description | Config File |
|--------|-------------|-------------|
| **lsp** | Native LSP + Mason + Conform | `nvim/lua/teni/plugins/lsp.lua` |
| **blink.cmp** | Fast autocompletion engine | `nvim/lua/teni/plugins/lsp.lua` |
| **lint** | Code linting (`nvim-lint`) | `nvim/lua/teni/plugins/lint.lua` |
| **autopairs** | Auto-close brackets/quotes | `nvim/lua/teni/plugins/autopairs.lua` |
| **ai** | AI assistance (if enabled) | `nvim/lua/teni/plugins/ai.lua` |

### 🛠️ Tools

| Plugin | Description | Config File |
|--------|-------------|-------------|
| **telescope** | Fuzzy finder and picker | `nvim/lua/teni/plugins/telescope.lua` |
| **gitsigns** | Git integration in buffers | `nvim/lua/teni/plugins/gitsigns.lua` |
| **debug** | Debugging (`nvim-dap`) | `nvim/lua/teni/plugins/debug.lua` |

---

## ⌨️ Keymaps Cheat Sheet

### General

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `;` | Enter Command Mode (`:`) |
| `jk` | Exit Insert Mode (`<Esc>`) |
| `<Esc>` | Clear search highlight (`nohlsearch`) |
| `<leader>q` | Open Diagnostic Quickfix list |

### Navigation & Tabs

| Key | Action |
|-----|--------|
| `tn` | New Tab |
| `tj` | Previous Tab |
| `tk` | Next Tab |
| `<C-h/j/k/l>` | Window navigation |

### 🔍 Telescope (Search)

| Key | Action |
|-----|--------|
| `<C-p>` / `<leader>sf` | Find Files |
| `<leader>sg` | Live Grep (Global search) |
| `<leader>sw` | Grep current word |
| `<leader><leader>` | Find Buffers |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>sh` | Search Help |
| `<leader>sk` | Search Keymaps |
| `<leader>s.` | Recent Files |

*Inside Telescope:*
- `<C-j/k>`: Move selection
- `<C-t>`: Open in new tab

### 🛠️ LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `grd` | **G**o to **D**efinition |
| `grr` | **G**o to **R**eferences |
| `grn` | **R**e**n**ame Symbol |
| `gra` | Code **A**ctions |
| `gO` | Document Symbols |
| `L` | Show line diagnostics (float) |
| `<leader>th` | Toggle Inlay Hints |

### 🐛 Debugging (DAP)

| Key | Action |
|-----|--------|
| `<F5>` | Start / Continue |
| `<F1>` | Step Into |
| `<F2>` | Step Over |
| `<F3>` | Step Out |
| `<F7>` | Toggle Debug UI |
| `<leader>b` | Toggle Breakpoint |
| `<leader>B` | Set Conditional Breakpoint |

### 📂 File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<C-e>` | Toggle Explorer |

### 📝 Git (Gitsigns)

| Key | Action |
|-----|--------|
| `]c` | Next Hunk |
| `[c` | Prev Hunk |
| `<leader>hs` | Stage Hunk |
| `<leader>hr` | Reset Hunk |
| `<leader>hp` | Preview Hunk |
| `<leader>hb` | Blame Line |
| `<leader>hd` | Diff This |

---

## 📦 Installation

```bash
# Clone
git clone https://github.com/yourusername/Teni.nvim.git ~/.config/Teni.nvim

# Install
cd ~/.config/Teni.nvim
chmod +x install.sh
./install.sh
```

## 📄 Structure

- `nvim/lua/teni/options.lua`: Vim settings (numbers, spaces, etc.)
- `nvim/lua/teni/keymaps.lua`: General keybindings
- `nvim/lua/teni/plugins/`: Plugin specs (one file per plugin group)
