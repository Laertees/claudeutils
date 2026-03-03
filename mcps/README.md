# MCP Server Configs

Each subdirectory contains setup instructions and config for one MCP server.

## Structure per MCP

```
mcps/<mcp-name>/
  README.md        - What it does, setup steps (Mac + Windows)
  settings.json    - The MCP config snippet to add to Claude settings
  requirements.txt - Python deps (if applicable)
  package.json     - Node deps (if applicable)
```

## Adding a new MCP

1. Create a dir: `mcps/<mcp-name>/`
2. Add a README with install steps for both platforms
3. Add the settings.json snippet showing the `mcpServers` entry
4. Test on both Mac and Windows, note any platform differences
