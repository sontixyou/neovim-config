# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration repository using **Necromancer** as the plugin manager. Necromancer is a commit-based versioning plugin manager that ensures reproducible plugin installations.

## Plugin Management with Necromancer

### Installing Plugins

1. **Add plugin to `.necromancer.json`**: Follow this format:
```json
{
  "name": "plugin-name",
  "repo": "https://github.com/owner/plugin-name",
  "commit": "full-commit-hash"
}
```
- Extract plugin name from the GitHub URL (e.g., `treesj` from `https://github.com/Wansmer/treesj`)
- Include dependencies if needed using `"dependencies": ["dep1", "dep2"]`

2. **Run installation**: `necromancer install`

### Common Necromancer Commands

- `necromancer install` - Install all plugins from `.necromancer.json`
- `necromancer update` - Update plugins to latest configured commits
- `necromancer list` - List installed plugins and status
- `necromancer verify --fix` - Verify and repair corrupted installations
- `necromancer clean --dry-run` - Preview plugins to be removed
- `necromancer clean --force` - Remove plugins not in config

## Architecture

### Main Configuration File: `init.lua`

The entire Neovim configuration is contained in a single `init.lua` file with the following structure:

1. **Leader Key Setup**: Space is set as both leader and local leader
2. **Editor Settings**: Indentation (2 spaces), spell check, clipboard sync, undo settings, auto-reload on external changes, yank highlight
3. **Core Keymaps**: Insert mode (`jj` to escape), terminal, window management, file path copying, better indenting
4. **Necromancer Setup**: Auto-clones and configures necromancer.nvim from GitHub
5. **Plugin Configurations**: nvim-treesitter, Telescope, treesj, autoclose, auto-session, bufferline, gitsigns, diffview, neo-tree, blink.cmp, conform.nvim
6. **Testing Setup**: vim-test with auto-detection for Jest/Vitest and RSpec
7. **LSP Configuration**: ruby_lsp, ts_ls, copilot, phpactor, rust-analyzer, tailwindcss

### Plugin Loading System

Necromancer installs plugins to `~/.local/share/nvim/necromancer/plugins/`. Auto-clones necromancer.nvim if not present.

### Key Plugins and Their Purpose

- **nvim-treesitter**: Syntax highlighting for Lua, Rust, Ruby, TypeScript, PHP with auto-install
- **nvim-ts-autotag**: Auto-close and auto-rename HTML/JSX tags
- **telescope.nvim**: Fuzzy finder for files, grep, buffers, help tags; ignores .git directory
- **neo-tree.nvim**: File explorer with filesystem, buffers, git status, document symbols
- **vim-test**: Test runner with auto-detection for Vitest/Jest (checks config files) and RSpec
- **conform.nvim**: Formatter with support for Biome, Prettier, RuboCop, phpcbf, rustfmt, stylelint
- **auto-session**: Automatic session save/restore with directory-based sessions
- **blink.cmp**: Rust-based completion engine with LSP integration
- **gitsigns.nvim**: Git diff indicators (shows diff against HEAD, not index)
- **diffview.nvim**: Side-by-side diff viewing and file history
- **vim-rails**: Rails project integration (navigation, commands)
- **tokyonight.nvim**: Colorscheme (tokyonight-storm)

### Important Configuration Details

- **Treesitter Languages**: Lua, Rust, Ruby, TypeScript, PHP
- **Neo-tree**: Shows dotfiles and git-ignored files, always displays common config files (.gitignore, .env, .rubocop.yml, etc.)
- **Telescope**: Configured to ignore `.git/` directory, shows hidden files by default
- **Blink.cmp**: Uses 'enter' preset, preselect disabled, sources: lsp, path, snippets, buffer
  - **重要**: `.necromancer.json`では必ずgitタグのコミットを使用すること。タグのないコミットではプリビルドバイナリをダウンロードできず起動時にエラーが発生する。タグのコミットは`git rev-parse <tag>^{commit}`で取得可能
- **Gitsigns**: Shows diff against HEAD (staged changes remain visible)
- **Yank Highlight**: Orange color (#ff9e64), 300ms timeout
- **Auto-reload**: Files reload on FocusGained, BufEnter, CursorHold

### Formatter Configuration (conform.nvim)

Format on save enabled with 3s timeout. Formatters by language:
- **JavaScript/TypeScript**: Biome → Prettier (fallback)
- **Ruby**: RuboCop → LSP (fallback)
- **PHP**: phpcbf
- **Rust**: rustfmt → LSP (fallback)
- **CSS/SCSS/Sass**: stylelint
- **All files**: trim_whitespace

### Test Runner Auto-Detection

vim-test automatically detects the test runner based on project config files:
- **Vitest**: vitest.config.*, vite.config.*
- **Jest**: jest.config.*
- Default: Vitest if no config found

### LSP Configuration

Uses **Neovim 0.10+ native LSP** (`vim.lsp.config()` and `vim.lsp.enable()`):

- **ruby_lsp**: Ruby/ERB, auto-formatter, root markers: Gemfile, .git
- **ts_ls**: JavaScript/TypeScript/JSX/TSX, root markers: package.json, tsconfig.json, .git
- **copilot**: 24+ filetypes, inline completion (Neovim 0.11+)
- **phpactor**: PHP, root markers: composer.json, .git
- **rust_analyzer**: Rust with clippy on save, allFeatures enabled
- **tailwindcss**: CSS/JS/TS files for Tailwind classes

All LSP servers integrated with blink.cmp for completion.

## Key Bindings Reference

### Global
- `<Space>` - Leader key
- `jj` in insert mode - Escape to normal mode
- `;` in normal mode - Command mode
- `<C-s>` - Save file (works in insert, visual, normal, select modes)

### Window Management
- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>se` - Make split windows equal width
- `<leader>sx` - Close current split
- `<C-h/j/k/l>` - Navigate between windows

### File Navigation & Search
- `<leader><leader>` - Telescope find files (includes hidden files)
- `<leader>fg` - Telescope live grep
- `<leader>fb` - Telescope buffers
- `<leader>fh` - Telescope help tags
- `<leader>e` - Toggle neo-tree file explorer
- `<leader>ge` - Toggle git status explorer
- `<leader>E` - Toggle git status (same as <leader>ge)

### Buffer Management (bufferline)
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer
- `<leader>bp` - Toggle pin buffer
- `<leader>bP` - Delete non-pinned buffers
- `<leader>bo` - Delete other buffers
- `<leader>br` - Delete buffers to the right
- `<leader>bl` - Delete buffers to the left
- `gb` - Pick buffer

### Session Management (auto-session)
- `<leader>ss` - Save session
- `<leader>sr` - Restore session
- `<leader>sd` - Delete session
- `<leader>sf` - Search sessions

### Git Integration (gitsigns)
- `]c` - Next hunk
- `[c` - Previous hunk

### Diff Viewing (diffview)
- `<leader>dvo` - Open diff view
- `<leader>dvc` - Close diff view
- `<leader>dvh` - File history (current file)
- `<leader>dvf` - File history (all files)
- `<leader>dvr` - Refresh diff view

### Testing (vim-test)
- `<leader>tt` - Run test nearest to cursor
- `<leader>tT` - Run current test file
- `<leader>tl` - Run last test
- `<leader>ta` - Run all tests (test suite)

### LSP Keybindings (available when LSP attaches)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Show references
- `gi` - Go to implementation
- `K` - Show hover documentation
- `<C-k>` - Signature help
- `<leader>ca` - Code action
- `<leader>rn` - Rename symbol
- `<leader>f` - Format buffer (async, uses conform.nvim)
- `<leader>d` - Show diagnostic in float
- `[d` / `]d` - Previous/next diagnostic
- `<tab>` (insert mode) - Accept inline completion (Copilot)

### Completion (blink.cmp)
- `<CR>` (Enter) - Accept selected completion
- `<C-Space>` - Open completion menu or documentation
- `<C-n>` / `<C-p>` - Navigate completion items (or arrow keys)
- `<C-e>` - Close completion menu
- `<C-k>` - Toggle signature help

### Utilities
- `<leader>cp` - Copy relative file path to clipboard
- `<leader>cP` - Copy absolute file path to clipboard
- `,b` - Insert `debugger` on new line

### Terminal Mode
- `jj` - Exit terminal mode and close terminal

## Development Workflow

### Prerequisites

**Required versions:**
- **Neovim 0.11+** (0.11+ required for inline completion API)
- **Node.js 22+** (for Copilot and TypeScript LSP)

**Language servers:**
- **Ruby**: `gem install ruby-lsp`
- **TypeScript/JavaScript**: `npm install -g typescript-language-server`
- **Copilot**: `npm install -g @github/copilot-language-server` (optional)
- **PHP**: Build phpactor from source (configured at `~/projects/php-projects/phpactor/bin/phpactor`)
- **Rust**: `rustup component add rust-analyzer`
- **TailwindCSS**: `npm install -g @tailwindcss/language-server`

**Formatters (for conform.nvim):**
- **Biome**: `npm install -D @biomejs/biome` (project-local)
- **Prettier**: `npm install -g prettier` (fallback)
- **RuboCop**: `gem install rubocop`
- **stylelint**: `npm install -g stylelint`
- **phpcbf**: Install via Composer

### Modifying Configuration

1. Edit `init.lua` for configuration changes
2. For new plugins: update `.necromancer.json` with exact commit hash, then run `necromancer install`
3. Restart Neovim or `:source ~/.config/nvim/init.lua` to apply changes

### LSP Setup

LSP keybindings are set up via the `LspAttach` autocmd, which applies them only when an LSP client successfully attaches to a buffer.

**Configured language servers:**
- **ruby_lsp**: Ruby and ERB files
- **ts_ls**: JavaScript, TypeScript, JSX, TSX files
- **copilot**: 24+ filetypes with inline completion
- **phpactor**: PHP files
- **rust_analyzer**: Rust files with clippy integration
- **tailwindcss**: CSS/JS/TS for Tailwind classes

All LSP servers integrate with blink.cmp for completion.

### Testing Workflow

**vim-test** runs tests using the neovim strategy (results in split window).

**Auto-detection:** Checks for vitest.config.* or vite.config.* → Vitest, otherwise jest.config.* → Jest. Default: Vitest.

**Test file patterns:** `*.test.{js,jsx,ts,tsx}`, `*.spec.{js,jsx,ts,tsx}`

**RSpec:** Automatically detects for Ruby files in `spec/` directory
