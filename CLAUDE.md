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

1. **Leader Key Setup** (lines 1-3): Space is set as both leader and local leader
2. **Editor Settings** (lines 5-26): Indentation, spell check, clipboard, undo settings
3. **Keymaps** (lines 29-50): Custom keybindings for insert mode, terminal, windows, and navigation
4. **Denops Configuration** (lines 52-79): Loads denops.vim and denops plugins from necromancer directory
5. **Plugin Configurations** (lines 81-214): Setup for nvim-treesitter, Telescope, toggleterm, treesj, autoclose, and neo-tree
6. **Additional Keybinds** (lines 217-229): Plugin-specific keybindings

### Plugin Loading System

Necromancer installs plugins to `~/.local/share/nvim/necromancer/plugins/`. The init.lua:
1. Loads `denops.vim` first (required for denops-based plugins)
2. Loads all other plugins from the necromancer directory
3. Auto-discovers denops plugins on VimEnter with a 100ms delay

### Key Plugins and Their Purpose

- **denops.vim**: Enables Neovim plugins written in TypeScript/JavaScript via Deno
- **nvim-treesitter**: Syntax highlighting and code parsing for Lua, Rust, Ruby, TypeScript
- **telescope.nvim**: Fuzzy finder for files, grep, buffers, help tags
- **toggleterm.nvim**: Terminal management (configured for vertical split)
- **neo-tree.nvim**: File explorer with filesystem, buffers, git status, and document symbols
- **treesj**: Split/join code blocks
- **autoclose.nvim**: Auto-close brackets and quotes

### Important Configuration Details

- **Deno Path**: Hardcoded to `/opt/homebrew/bin/deno` (line 52)
- **Treesitter Languages**: Configured for Lua, Rust, Ruby, TypeScript with auto-install enabled
- **Toggleterm**: Opens vertically by default with `<C-\>` or `<leader>tt`
- **Neo-tree**: Shows dotfiles and git-ignored files, configured to always show common config files
- **Telescope**: Main file finder is `<leader><leader>`

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

### Plugin Keybindings
- `<leader><leader>` - Telescope find files
- `<leader>fg` - Telescope live grep
- `<leader>fb` - Telescope buffers
- `<leader>fh` - Telescope help tags
- `<leader>tt` - Toggle terminal
- `<leader>e` - Toggle neo-tree file explorer
- `<leader>ge` - Toggle git status explorer
- `,b` - Insert `debugger` on new line (for debugging)

### Terminal Mode
- `jj` - Exit terminal mode and close terminal

## Development Workflow

When modifying this configuration:
1. Edit `init.lua` for configuration changes
2. For new plugins: update `.necromancer.json` with exact commit hash, then run `necromancer install`
3. Restart Neovim or `:source init.lua` to apply changes
4. Verify denops plugins load correctly (100ms delay on startup)
