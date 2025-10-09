# Neovim Configuration

This Neovim configuration provides LSP support, syntax highlighting with Tree-sitter, and other essential features.

## Features

- **LSP Support**: Language Server Protocol integration using nvim-lspconfig
- **Syntax Highlighting**: Advanced syntax highlighting with nvim-treesitter
- **Denops Integration**: Support for Denops plugins
- **Lua Language Server**: Configured with lua_ls for Lua development

## Requirements

### System Dependencies

To use the LSP functionality, you need to install the language servers:

#### Lua Language Server (lua_ls)

**Installation Options:**

1. **Using Mason (Recommended)**:
   ```bash
   # Install Mason plugin first, then use :MasonInstall lua-language-server
   ```

2. **Manual Installation**:
   
   **macOS (via Homebrew)**:
   ```bash
   brew install lua-language-server
   ```
   
   **Ubuntu/Debian**:
   ```bash
   # Option 1: Using snap
   sudo snap install lua-language-server
   
   # Option 2: Download from GitHub releases
   wget https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-[version]-linux-x64.tar.gz
   tar -xzf lua-language-server-*.tar.gz
   sudo mv lua-language-server /usr/local/bin/
   ```
   
   **Arch Linux**:
   ```bash
   pacman -S lua-language-server
   ```

### Neovim Requirements

- Neovim >= 0.8.0 (required for LSP and Tree-sitter features)
- Git (for plugin management)

## LSP Keybindings

The following keybindings are available when an LSP server is attached:

- `gD` - Go to declaration
- `gd` - Go to definition
- `K` - Show hover information
- `gi` - Go to implementation  
- `<C-k>` - Show signature help
- `<space>wa` - Add workspace folder
- `<space>wr` - Remove workspace folder
- `<space>wl` - List workspace folders
- `<space>D` - Go to type definition
- `<space>rn` - Rename symbol
- `<space>ca` - Code action
- `gr` - Show references
- `<space>f` - Format buffer

## Plugin Management

This configuration uses the "necromancer" plugin manager. Plugins are defined in `.necromancer.json` and installed to `~/.local/share/nvim/necromancer/plugins/`.

### Current Plugins

- **denops.vim**: Base framework for Denops plugins
- **denops-helloworld**: Example Denops plugin
- **nvim-treesitter**: Syntax highlighting and parsing
- **nvim-lspconfig**: LSP client configurations

## Installation

1. Clone this repository to your Neovim configuration directory:
   ```bash
   git clone <repository-url> ~/.config/nvim
   ```

2. Install the required language servers (see Requirements section above)

3. Start Neovim - plugins will be loaded automatically

## Troubleshooting

If LSP features are not working:

1. Ensure the language server is installed and in your PATH
2. Check `:LspInfo` to see the status of language servers
3. Verify the language server is configured for your file type

For lua_ls specifically, make sure the `lua-language-server` executable is available in your system PATH.