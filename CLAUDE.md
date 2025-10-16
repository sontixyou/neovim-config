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
2. **Editor Settings**: Indentation (2 spaces), spell check, clipboard sync, undo settings, auto-reload on external changes
3. **Core Keymaps**: Insert mode (`jj` to escape), terminal, window management, file path copying
4. **Denops Configuration**: Loads denops.vim first, then other plugins from necromancer directory with 100ms auto-discovery delay
5. **Plugin Configurations**: nvim-treesitter, Telescope (with .git filtering), toggleterm, treesj, autoclose, neo-tree
6. **Testing Setup**: vim-test integration with neovim strategy
7. **LSP Configuration**: ruby-lsp with comprehensive keybindings via LspAttach autocmd

### Plugin Loading System

Necromancer installs plugins to `~/.local/share/nvim/necromancer/plugins/`. The init.lua:
1. Loads `denops.vim` first (required for denops-based plugins)
2. Loads all other plugins from the necromancer directory
3. Auto-discovers denops plugins on VimEnter with a 100ms delay

### Key Plugins and Their Purpose

- **denops.vim**: Enables Neovim plugins written in TypeScript/JavaScript via Deno
- **nvim-treesitter**: Syntax highlighting and code parsing for Lua, Rust, Ruby, TypeScript with auto-install
- **telescope.nvim**: Fuzzy finder for files (shows hidden files), grep, buffers, help tags; ignores .git directory
- **toggleterm.nvim**: Terminal management (vertical split by default)
- **neo-tree.nvim**: File explorer with filesystem, buffers, git status, and document symbols; always shows dotfiles and common config files
- **vim-test**: Test runner with neovim strategy for running nearest test, file, last test, or entire suite
- **treesj**: Split/join code blocks using treesitter
- **autoclose.nvim**: Auto-close brackets and quotes
- **seeker.nvim**: Denops-based fuzzy finder (currently commented out in favor of Telescope)
- **ruby-lsp**: Ruby Language Server Protocol support with auto-formatting

### Important Configuration Details

- **Deno Path**: Hardcoded to `/opt/homebrew/bin/deno`
- **Treesitter Languages**: Lua, Rust, Ruby, TypeScript with auto-install enabled
- **Toggleterm**: Opens vertically by default with `<C-\>`
- **Neo-tree**: Shows dotfiles and git-ignored files, always displays common config files (.gitignore, .env, .rubocop.yml, etc.)
- **Telescope**: Configured to ignore `.git/` directory, shows hidden files by default
- **LSP**: ruby-lsp enabled with auto-formatter, uses Gemfile or .git as root markers
- **Auto-reload**: Files automatically reload when changed externally (FocusGained, BufEnter, CursorHold)

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

### Testing (vim-test)
- `<leader>tt` - Run test nearest to cursor
- `<leader>tT` - Run current test file
- `<leader>tl` - Run last test
- `<leader>ta` - Run all tests (test suite)

### LSP Keybindings (Ruby files)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Show references
- `gi` - Go to implementation
- `K` - Show hover documentation
- `<C-k>` - Signature help
- `<leader>ca` - Code action
- `<leader>rn` - Rename symbol
- `<leader>f` - Format buffer (async)
- `<leader>d` - Show diagnostic in float
- `[d` / `]d` - Previous/next diagnostic

### Utilities
- `<leader>cp` - Copy relative file path to clipboard
- `<leader>cP` - Copy absolute file path to clipboard
- `<C-\>` - Toggle terminal
- `,b` - Insert `debugger` on new line

### Terminal Mode
- `jj` - Exit terminal mode and close terminal

## Development Workflow

### Prerequisites

- Install `ruby-lsp` gem for Ruby development: `gem install ruby-lsp`
- Ensure Deno is installed at `/opt/homebrew/bin/deno` for denops plugins

### Modifying Configuration

1. Edit `init.lua` for configuration changes
2. For new plugins: update `.necromancer.json` with exact commit hash, then run `necromancer install`
3. Restart Neovim or `:source ~/.config/nvim/init.lua` to apply changes
4. Verify denops plugins load correctly (100ms delay on startup)

### LSP Setup

The ruby-lsp is configured to auto-start on Ruby and ERB files. LSP keybindings are set up via the `LspAttach` autocmd, which applies them only when an LSP client successfully attaches to a buffer. This ensures LSP functionality is only available when the language server is actually running.

### Testing Workflow

Tests run using the neovim strategy, which opens results in a split window within Neovim. The test runner (vim-test) automatically detects the test framework based on file patterns and project structure.
