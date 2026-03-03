# claudeutils

Cross-platform reference project for Claude Code configurations: MCP servers, skills, agents, and workflows.

## Project structure

- `configs/` - Portable Claude Code configuration files (settings, keybindings)
- `mcps/` - MCP server setup guides and configs, one dir per MCP
- `skills/` - Custom skill definitions and documentation
- `agents/` - Agent configurations and examples
- `scripts/` - Cross-platform setup/sync scripts
- `notes/` - Working notes and findings

## Cross-platform notes

- Mac config dir: `~/.claude/`
- Windows config dir: `%USERPROFILE%\.claude\`
- Settings file: `settings.json` (in config dir)
- Project settings: `.claude/settings.json` (in repo root)
- Keybindings: `keybindings.json` (in config dir)

## Conventions

- Document each MCP/skill/agent in its own directory with a README
- Include both Mac and Windows setup steps where they differ
- Keep secrets out of the repo - use .env files (gitignored)
