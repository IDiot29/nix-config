# Neovim Keybindings Reference

Leader key: `Space`

## File Navigation (Telescope)

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>ff` | Find Files | Search for files in current directory |
| `<leader>fg` | Live Grep | Search text in all files |
| `<leader>fb` | Find Buffers | List and switch between open buffers |
| `<leader>fh` | Help Tags | Search help documentation |
| `<leader>fo` | Old Files | Recently opened files |

## File Explorer

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>e` | Toggle File Tree | Open/Close NvimTree file explorer |

**Note:** File tree will NOT auto-open when you type `nvim`. Use `<leader>e` to open it manually.

## Window Navigation

| Keybind | Action | Description |
|---------|--------|-------------|
| `Ctrl+h` | Move Left | Switch to left window |
| `Ctrl+j` | Move Down | Switch to bottom window |
| `Ctrl+k` | Move Up | Switch to top window |
| `Ctrl+l` | Move Right | Switch to right window |

## Buffer Navigation

| Keybind | Action | Description |
|---------|--------|-------------|
| `Shift+h` | Previous Buffer | Go to previous buffer |
| `Shift+l` | Next Buffer | Go to next buffer |

## Tab Navigation

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>tn` | Next Tab | Go to next tab |
| `<leader>tp` | Previous Tab | Go to previous tab |
| `<leader>tc` | Close Tab | Close current tab |

## LSP (Language Server Protocol)

| Keybind | Action | Description |
|---------|--------|-------------|
| `gd` | Go to Definition | Jump to symbol definition |
| `gr` | Show References | List all references |
| `K` | Hover Documentation | Show documentation popup |
| `<leader>rn` | Rename | Rename symbol under cursor |
| `<leader>ca` | Code Action | Show available code actions |

## Git Integration

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>gg` | LazyGit | Open LazyGit in new tab |

GitSigns is also enabled for inline git status in the sign column.

**How it works:**
- Opens in a new tab (won't mess with your current layout)
- Press `q` to quit lazygit - tab closes automatically
- Or use `<leader>tc` to manually close the tab

## Code Editing

| Keybind | Action | Description |
|---------|--------|-------------|
| `gcc` | Toggle Comment Line | Comment/uncomment current line (Normal mode) |
| `gc` | Toggle Comment Block | Comment/uncomment selection (Visual mode) |

### Visual Mode Indenting

| Keybind | Action | Description |
|---------|--------|-------------|
| `<` | Indent Left | Decrease indentation (keeps selection) |
| `>` | Indent Right | Increase indentation (keeps selection) |

## Search

| Keybind | Action | Description |
|---------|--------|-------------|
| `<leader>h` | Clear Highlight | Remove search highlighting |

## Auto-completion (nvim-cmp)

When the completion menu appears, nvf provides these default keybindings:

| Keybind | Action | Description |
|---------|--------|-------------|
| `Ctrl+n` | Next Item | Navigate to next suggestion |
| `Ctrl+p` | Previous Item | Navigate to previous suggestion |
| `Tab` | Next/Expand | Next item or expand snippet |
| `Shift+Tab` | Previous/Jump | Previous item or jump back in snippet |
| `Enter` | Confirm | Accept selected suggestion |
| `Ctrl+e` | Close | Close completion menu |

**Note:** Arrow keys (↑/↓) work in the completion menu by default in nvf.

## Additional Features

### Auto-pairs
Automatically closes brackets, quotes, and parentheses.

### Which-Key
Press `Space` (leader) and wait briefly to see all available keybindings starting with Space.

### Treesitter
Advanced syntax highlighting and code folding enabled.

## Language Support

Configured languages with LSP, formatting, and diagnostics:
- **Nix** (nixd LSP)
- **Rust** (rust-analyzer)
- **Lua** (lua-language-server)
- **Bash** (shellcheck, shfmt)
- **TypeScript/JavaScript** (tsserver)
- **Python** (pyright)
- **Markdown**
- **YAML/Kubernetes** (yaml-language-server, actionlint)

## Tips

1. **Format on save** is enabled for all languages
2. **Inlay hints** are enabled for supported languages
3. **Diagnostic virtual text** shows errors/warnings inline
4. **Persistent undo** with `undofile` - your changes persist across sessions
5. **Smart case search** - case-insensitive unless you type uppercase
