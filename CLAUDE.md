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
4. **Denops Configuration**: Loads denops.vim first, then other plugins from necromancer directory with 100ms auto-discovery delay
5. **Plugin Configurations**: nvim-treesitter, Telescope, toggleterm, treesj, autoclose, bufferline, gitsigns, diffview, neo-tree, blink.cmp
6. **Testing Setup**: vim-test integration with neovim strategy for Jest and RSpec
7. **LSP Configuration**: ruby_lsp, ts_ls, and copilot with comprehensive keybindings via LspAttach autocmd

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
- **vim-test**: Test runner with neovim strategy for Jest, RSpec, and other test frameworks
- **treesj**: Split/join code blocks using treesitter
- **autoclose.nvim**: Auto-close brackets and quotes
- **bufferline.nvim**: Buffer/tab management with visual indicators, diagnostics, and pin functionality
- **gitsigns.nvim**: Git diff indicators in sign column with hunk navigation and staging
- **diffview.nvim**: Advanced diff viewing with side-by-side comparison and file history
- **blink.cmp**: Modern Rust-based completion engine with LSP integration and snippet support
- **seeker.nvim**: Denops-based fuzzy finder (currently commented out in favor of Telescope)
- **ruby-lsp**: Ruby Language Server Protocol support with auto-formatting
- **ts_ls**: TypeScript/JavaScript Language Server for full IDE features
- **copilot**: GitHub Copilot integration with inline completion support

### Important Configuration Details

- **Deno Path**: Hardcoded to `/opt/homebrew/bin/deno`
- **Treesitter Languages**: Lua, Rust, Ruby, TypeScript with auto-install enabled
- **Toggleterm**: Opens vertically by default with `<C-\>`
- **Neo-tree**: Shows dotfiles and git-ignored files, always displays common config files (.gitignore, .env, .rubocop.yml, etc.)
- **Telescope**: Configured to ignore `.git/` directory, shows hidden files by default
- **Blink.cmp**: Uses 'enter' preset (Enter confirms completion), preselect disabled, sources: lsp, path, snippets, buffer
- **Gitsigns**: Shows diff against HEAD (not index), so staged changes remain visible
- **Bufferline**: Shows diagnostics, supports pinning buffers, neo-tree offset
- **Yank Highlight**: Orange color (#ff9e64) on yanked text, 300ms timeout
- **Auto-reload**: Files automatically reload when changed externally (FocusGained, BufEnter, CursorHold)

### LSP Configuration

Uses **Neovim 0.10+ native LSP** (`vim.lsp.config()` and `vim.lsp.enable()`):

- **ruby_lsp**: Ruby and ERB files, auto-formatter, root markers: Gemfile, .git
- **ts_ls**: JavaScript/TypeScript/JSX/TSX files, root markers: package.json, tsconfig.json, jsconfig.json, .git
- **copilot**: 17 language filetypes, inline completion enabled (Neovim 0.11+)

All LSP servers are integrated with blink.cmp for enhanced completion capabilities.

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
- `<leader>f` - Format buffer (async)
- `<leader>d` - Show diagnostic in float
- `[d` / `]d` - Previous/next diagnostic

### Completion (blink.cmp)
- `<CR>` (Enter) - Accept selected completion
- `<C-Space>` - Open completion menu or documentation
- `<C-n>` / `<C-p>` - Navigate completion items (or arrow keys)
- `<C-e>` - Close completion menu
- `<C-k>` - Toggle signature help

### Utilities
- `<leader>cp` - Copy relative file path to clipboard
- `<leader>cP` - Copy absolute file path to clipboard
- `<C-\>` - Toggle terminal
- `,b` - Insert `debugger` on new line

### Terminal Mode
- `jj` - Exit terminal mode and close terminal

## Development Workflow

### Prerequisites

**Required versions:**
- **Neovim 0.10+** (0.11+ recommended for Copilot inline completion)
- **Node.js 22+** (for Copilot and TypeScript LSP)
- **Deno** installed at `/opt/homebrew/bin/deno` (for denops plugins)

**Language servers:**
- **Ruby**: `gem install ruby-lsp`
- **TypeScript/JavaScript**: `npm install -g typescript-language-server`
- **Copilot**: `npm install -g @github/copilot-language-server` (optional)

### Modifying Configuration

1. Edit `init.lua` for configuration changes
2. For new plugins: update `.necromancer.json` with exact commit hash, then run `necromancer install`
3. Restart Neovim or `:source ~/.config/nvim/init.lua` to apply changes
4. Verify denops plugins load correctly (100ms delay on startup)

### LSP Setup

LSP keybindings are set up via the `LspAttach` autocmd, which applies them only when an LSP client successfully attaches to a buffer. This ensures LSP functionality is only available when the language server is actually running.

**Configured language servers:**
- **ruby_lsp**: Ruby and ERB files
- **ts_ls**: JavaScript, TypeScript, JSX, TSX files
- **copilot**: Multi-language inline completion

All LSP servers integrate with blink.cmp for completion.

### Testing Workflow

**vim-test** runs tests using the neovim strategy (results in split window).

**Jest configuration:**
- JavaScript/TypeScript test files: `*.test.js`, `*.spec.js`, `*.test.ts`, `*.spec.ts`, `*.test.tsx`, `*.spec.tsx`
- Executable: `npx jest`
- Automatically detects test framework based on file patterns

**RSpec configuration:**
- Automatically detects RSpec for Ruby files in `spec/` directory
