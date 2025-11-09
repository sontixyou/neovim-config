# Setup

## Requirements

- Install Neovim ver 0.12 or higher
  - copilot-lsp-server requires Neovim ver 0.12 or higher
- Install Node.js ver 22 or higher
  - copilot-lsp-server requires Node.js ver 22 or higher
- Install Deno
  - denops.vim plugins require Deno runtime
  - see https://deno.land/manual/getting_started/installation
- Install necromaner.nvim
  - see https://github.com/sontixyou/necromancer.nvim
- Install ripgrep
  - Required for Telescope's live grep functionality
  - see https://github.com/BurntSushi/ripgrep#installation
- Install Nerd Font
  - Required for proper icon display in bufferline, neo-tree, and other plugins
  - see https://www.nerdfonts.com/font-downloads
- `gem install ruby-lsp`
  - development of Rails application
- `npm install -g typescript typescript-language-server`
  - for development of Typescript application
- `npm install -g @github/copilot-language-server`
  - GitHub Copilot language server for AI-powered code completion
- Install phpactor (for PHP development)
  ```sh
  cd ~/projects/php-projects
  git clone https://github.com/phpactor/phpactor.git
  cd phpactor
  composer install
  ```
  - Language server for PHP development with completion, navigation, and refactoring

## Start Neovim

```sh
cd ~/.config/nvim
necromaner install
nvim .
```
