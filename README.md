# Neovim Configuration

Personal Neovim configuration using [Necromancer](https://github.com/sontixyou/necromancer.nvim) as the plugin manager.

## Requirements

- **Neovim 0.12+** (required for Copilot inline completion)
- **Node.js 22+** (required for Copilot)
- **ripgrep** (for Telescope live grep) - see https://github.com/BurntSushi/ripgrep#installation
- **Nerd Font** (for icons) - see https://www.nerdfonts.com/font-downloads

### Language Servers

```bash
# Ruby
gem install ruby-lsp

# TypeScript/JavaScript
npm install -g typescript typescript-language-server

# Copilot
npm install -g @github/copilot-language-server

# Rust
rustup component add rust-analyzer
```

### Formatters

```bash
# JavaScript/TypeScript
npm install -g prettier

# CSS/SCSS
npm install -g stylelint
```

## Installation

```bash
cd ~/.config/nvim
necromancer install
nvim .
```

## Plugins

| Plugin | Description |
|--------|-------------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and code parsing |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion engine |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatter |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer/tab management |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Diff viewer |
| [vim-test](https://github.com/vim-test/vim-test) | Test runner |
| [treesj](https://github.com/Wansmer/treesj) | Split/join code blocks |
| [autoclose.nvim](https://github.com/m4xshen/autoclose.nvim) | Auto-close brackets |
| [auto-session](https://github.com/rmagatti/auto-session) | Session management |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Color scheme |

## Key Bindings

Leader key: `<Space>`

### General

| Key | Description |
|-----|-------------|
| `jj` | Escape to normal mode (insert mode) |
| `;` | Command mode |
| `<C-s>` | Save file |

### File Navigation

| Key | Description |
|-----|-------------|
| `<leader><leader>` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>e` | Toggle file explorer |
| `<leader>ge` | Git status explorer |

### Buffer Management

| Key | Description |
|-----|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bp` | Toggle pin buffer |
| `<leader>bo` | Close other buffers |
| `gb` | Pick buffer |

### Window Management

| Key | Description |
|-----|-------------|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Equal splits |
| `<leader>sx` | Close split |
| `<C-h/j/k/l>` | Navigate windows |

### LSP

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Show references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format buffer |
| `<leader>d` | Show diagnostic |
| `[d` / `]d` | Previous/next diagnostic |

### Git

| Key | Description |
|-----|-------------|
| `]c` / `[c` | Next/previous hunk |
| `<leader>dvo` | Open diff view |
| `<leader>dvc` | Close diff view |
| `<leader>dvh` | File history (current) |
| `<leader>dvf` | File history (all) |

### Testing

| Key | Description |
|-----|-------------|
| `<leader>tt` | Test nearest |
| `<leader>tT` | Test file |
| `<leader>tl` | Test last |
| `<leader>ta` | Test all |

### Session

| Key | Description |
|-----|-------------|
| `<leader>ss` | Save session |
| `<leader>sr` | Restore session |
| `<leader>sd` | Delete session |
| `<leader>sf` | Search sessions |

### Utilities

| Key | Description |
|-----|-------------|
| `<leader>cp` | Copy relative file path |
| `<leader>cP` | Copy absolute file path |
| `,b` | Insert `debugger` |

## LSP Configuration

| Server | Languages |
|--------|-----------|
| ruby_lsp | Ruby, ERB |
| ts_ls | JavaScript, TypeScript |
| rust_analyzer | Rust |
| copilot | Multi-language |

## Format on Save

Automatic formatting is enabled via conform.nvim:

| Language | Formatter |
|----------|-----------|
| Ruby | rubocop |
| JavaScript/TypeScript | prettier |
| CSS/SCSS | stylelint |
| Rust | rustfmt |

## Plugin Management

```bash
# Install plugins
necromancer install

# Update plugins
necromancer update

# List plugins
necromancer list

# Verify installations
necromancer verify --fix

# Clean unused plugins
necromancer clean --force
```
