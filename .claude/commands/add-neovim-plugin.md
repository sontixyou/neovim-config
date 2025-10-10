# Neovimへプラグインを追加

次の手順に沿って進めること

1. @.necromancer.jsonにプラグインを追加

- plugin_nameは $ARGUMENTS にある URLの文字列から取得
  - https://github.com/Wansmer/treesj の場合、plugin_nameはtreesj
  - https://github.com/mason-org/mason-lspconfig.nvim の場合、plugin_nameはmason-lspconfig.nvim
- plugin_urlは $ARGUMENTS にある URLを使用する
  - https://github.com/Wansmer/treesj の場合、plugin_urlはhttps://github.com/Wansmer/treesj
  - https://github.com/mason-org/mason-lspconfig.nvim の場合、plugin_urlはhttps://github.com/mason-org/mason-lspconfig.nvim
- commit_argumentは $ARGUMENTS のcommit hashを使用

```json
{
    "name": "{plugin_name}",
    "repo": "{plugin_url}",
    "commit": "{commit_argument}"
```

2. necromancer install コマンドを実行
