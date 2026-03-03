# Hugging Face MCP Server

Search models, datasets, Spaces, papers, and documentation on the Hugging Face Hub
directly from Claude Code. Also run Gradio-based Spaces as tools (image generation,
TTS, OCR, etc.).

## What it provides

| Tool | Description |
|------|-------------|
| `hub_repo_search` | Search models, datasets, and Spaces with filters |
| `hub_repo_details` | Get details for specific repos (model cards, etc.) |
| `space_search` | Semantic search for HF Spaces |
| `paper_search` | Find ML research papers on the Hub |
| `hf_doc_search` | Search HF library documentation |
| `hf_doc_fetch` | Fetch full documentation pages |
| `dynamic_space` | Run Gradio Spaces as tools (image gen, TTS, OCR, etc.) |
| `hf_hub_community` | Profiles, followers, discussions, PRs, collections |
| `hf_whoami` | Check authenticated user |

## Setup options

There are three ways to set this up, from simplest to most flexible.

### Option A: Remote HTTP server with OAuth (recommended)

No local install needed. HF hosts the server; you authenticate via browser.

```bash
claude mcp add hf-mcp-server -t http https://huggingface.co/mcp?login
```

Then start Claude Code and follow the browser OAuth flow when prompted.

### Option B: Remote HTTP server with token

Same remote server, but using an explicit HF token instead of OAuth.

1. Create a token at https://huggingface.co/settings/tokens (Read access minimum)
2. Add the MCP:

```bash
claude mcp add hf-mcp-server \
  -t http https://huggingface.co/mcp \
  -H "Authorization: Bearer YOUR_HF_TOKEN"
```

### Option C: Self-hosted STDIO server

Run the server locally via npx. Useful for offline work or custom setups.

```bash
# Mac / Linux
claude mcp add-json hf-mcp-server '{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@llmindset/hf-mcp-server"],
  "env": { "HF_TOKEN": "YOUR_HF_TOKEN" }
}'
```

```powershell
# Windows (needs cmd wrapper for npx)
claude mcp add-json hf-mcp-server '{
  \"type\": \"stdio\",
  \"command\": \"cmd\",
  \"args\": [\"/c\", \"npx\", \"-y\", \"@llmindset/hf-mcp-server\"],
  \"env\": { \"HF_TOKEN\": \"YOUR_HF_TOKEN\" }
}'
```

## Configuration in settings files

### Remote HTTP (Options A/B)

Goes in `~/.claude.json` (auto-created by `claude mcp add`):

```json
{
  "mcpServers": {
    "hf-mcp-server": {
      "type": "http",
      "url": "https://huggingface.co/mcp",
      "headers": {
        "Authorization": "Bearer ${HF_TOKEN}"
      }
    }
  }
}
```

### STDIO (Option C)

```json
{
  "mcpServers": {
    "hf-mcp-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@llmindset/hf-mcp-server"],
      "env": {
        "HF_TOKEN": "${HF_TOKEN}"
      }
    }
  }
}
```

### Project-level `.mcp.json`

To share with a team (token via env var, not hardcoded):

```json
{
  "mcpServers": {
    "hf-mcp-server": {
      "type": "http",
      "url": "https://huggingface.co/mcp",
      "headers": {
        "Authorization": "Bearer ${HF_TOKEN}"
      }
    }
  }
}
```

## Authentication

### Getting a token

1. Go to https://huggingface.co/settings/tokens
2. Create a token with **Read** access (sufficient for search/docs)
3. Use broader access if you need job-running features

### Token delivery methods

| Method | Use case |
|--------|----------|
| OAuth (`?login` URL) | Personal interactive use, tokens auto-refresh |
| `Authorization` header | Explicit token in config, good for CI |
| `HF_TOKEN` env var | For STDIO mode or env-var expansion in config |

### Storing the token

Keep it out of git. Add to your shell profile:

```bash
# ~/.zshrc or ~/.bashrc
export HF_TOKEN="hf_xxxxxxxxxxxxxxxxxxxxx"
```

```powershell
# Windows PowerShell profile
$env:HF_TOKEN = "hf_xxxxxxxxxxxxxxxxxxxxx"
```

## Customizing available tools

You can enable/disable individual tools at:
https://huggingface.co/settings/mcp

## Verifying the setup

```bash
# List configured MCPs
claude mcp list

# Inside Claude Code
/mcp
```

Then try a query like "search for text-to-speech models" to confirm it works.

## Platform differences

| | Mac / Linux | Windows |
|---|---|---|
| Remote HTTP (Options A/B) | Works as-is | Works as-is |
| STDIO (Option C) | `"command": "npx"` | `"command": "cmd"`, `"args": ["/c", "npx", ...]` |
| Token storage | `~/.zshrc` / `~/.bashrc` | PowerShell profile or system env vars |
| OAuth credential store | macOS Keychain | Windows Credential Manager |

The remote HTTP option is the most portable since there's no local command to run.

## Links

- Docs: https://huggingface.co/docs/hub/en/hf-mcp-server
- GitHub: https://github.com/huggingface/hf-mcp-server
- Token settings: https://huggingface.co/settings/tokens
- Tool toggle: https://huggingface.co/settings/mcp
- npm (STDIO): https://www.npmjs.com/package/@llmindset/hf-mcp-server
