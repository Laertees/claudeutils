# Claude Code Configurations

Portable config files that can be synced between machines.

## Files

- `settings.json` - Global Claude Code settings (copy to `~/.claude/settings.json`)
- `keybindings.json` - Custom keybindings (copy to `~/.claude/keybindings.json`)

## Syncing between machines

Use the setup script in `scripts/` to symlink or copy configs to the right location.

### What's portable

- `settings.json` - MCP server configs, allowed tools, model preferences
- `keybindings.json` - Custom key bindings
- `.claude/settings.json` - Per-project settings (committed with the repo)

### What's NOT portable

- `credentials.json` - Auth tokens (machine-specific)
- `projects/` - Per-project memory and state
- MCP server paths may differ between Mac (`/Users/...`) and Windows (`C:\Users\...`)

## Handling path differences

For MCP configs that reference local paths, use the `{{HOME}}` placeholder in
template files and let the setup script expand them per-platform.
