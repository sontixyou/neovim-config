# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration repository using **Necromancer** as the plugin manager. Necromancer is a commit-based versioning plugin manager that ensures reproducible plugin installations.

The entire configuration lives in a single `init.lua` file. There are no split module files.

## Plugin Management with Necromancer

### Adding a New Plugin

1. Add the plugin entry to `.necromancer.json`:
```json
{
  "name": "plugin-name",
  "repo": "https://github.com/owner/plugin-name",
  "commit": "full-commit-hash"
}
```
- The `name` should match the repo name (e.g., `treesj` from `https://github.com/Wansmer/treesj`)
- Add `"dependencies": ["dep1", "dep2"]` if the plugin requires other plugins
- **blink.cmp は例外**: `.necromancer.json`では必ずgitタグのコミットを使用すること。タグのないコミットではプリビルドバイナリをダウンロードできず起動時にエラーが発生する。タグのコミットは`git rev-parse <tag>^{commit}`で取得可能

2. Run `necromancer install`
3. Add plugin configuration to `init.lua`

### Common Necromancer Commands

- `necromancer install` - Install all plugins from `.necromancer.json`
- `necromancer update` - Update plugins to latest configured commits
- `necromancer list` - List installed plugins and status
- `necromancer verify --fix` - Verify and repair corrupted installations
- `necromancer clean --dry-run` - Preview plugins to be removed
- `necromancer clean --force` - Remove plugins not in config

Plugins are installed to `~/.local/share/nvim/necromancer/plugins/`. Necromancer itself is auto-cloned on first launch.

## Architecture: `init.lua` Structure

The file follows this order — new configuration should be added in the appropriate section:

1. **Editor settings** (line ~1): Leader key (Space), indentation (2 spaces), spell check, clipboard sync, undo, auto-reload
2. **Core keymaps** (line ~50): `jj` escape, window management, file path copy, terminal
3. **Necromancer bootstrap** (line ~86): Auto-clone and setup
4. **Plugin configurations** (line ~99): Treesitter, Telescope, treesj, autoclose, auto-session, bufferline, gitsigns, diffview, neo-tree, blink.cmp, conform.nvim
5. **Test runner setup** (line ~379): vim-test with Vitest/Jest/RSpec auto-detection
6. **LSP configuration** (line ~491): LspAttach autocmd, then individual server configs

### LSP Setup Pattern

Uses Neovim 0.12+ native LSP API (`vim.lsp.config()` + `vim.lsp.enable()`). Each server follows this pattern:
```lua
vim.lsp.config('server_name', {
  cmd = { ... },
  filetypes = { ... },
  root_markers = { ... },
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
vim.lsp.enable('server_name')
```

Currently configured servers: **ruby_lsp**, **ts_ls**, **copilot**, **rust_analyzer**

LSP keybindings are set in the `LspAttach` autocmd and only apply when an LSP client attaches.

### Formatter Configuration (conform.nvim)

Format on save is enabled (3s timeout). Current formatters:
- **JavaScript/TypeScript/JSON**: prettier
- **Ruby**: rubocop (LSP fallback)
- **CSS/SCSS/Sass**: stylelint
- **Rust**: rustfmt (LSP fallback)
- **All files**: trim_whitespace

### Test Runner Auto-Detection

vim-test detects the runner via project config files:
- `vitest.config.*` or `vite.config.*` → Vitest
- `jest.config.*` → Jest
- No config found → Vitest (default)

RSpec is automatically used for Ruby files in `spec/`.

## Prerequisites

- **Neovim 0.12+** (required for inline completion API)
- **Node.js 22+** (for Copilot and TypeScript LSP)
- **ripgrep** (for Telescope live grep)
- **Nerd Font** (for icons in neo-tree, bufferline)

## Key Bindings

See `README.md` for the full key bindings reference. The most important ones:

- `<Space>` — Leader key
- `<leader><leader>` — Find files (Telescope)
- `<leader>fg` — Live grep
- `<leader>e` — Toggle file explorer (neo-tree)
- `<leader>tt` / `<leader>tT` — Run nearest test / test file
- `gd` / `gr` / `K` — Go to definition / references / hover (LSP)
- `<leader>f` — Format buffer
- `<leader>dvo` / `<leader>dvc` — Open/close diff view
