# Docker MCP Gateway

Centralized gateway that connects Claude Code to 300+ containerized MCP servers
from the Docker MCP Catalog. Each server runs in an isolated container with
restricted privileges, automatic credential injection, and OAuth handling.

## How it works

```
Claude Code → docker mcp gateway run → MCP Gateway → MCP Servers (containers)
```

The gateway starts as a stdio process. When Claude requests a tool, the gateway
pulls and starts the relevant server container on demand, injects credentials,
and returns results.

## Prerequisites

- Docker Desktop >= 4.62 (bundles the `docker mcp` CLI plugin)
- MCP Toolkit enabled in Docker Desktop settings

## Setup

### 1. Enable MCP Toolkit in Docker Desktop

1. Open Docker Desktop
2. Settings → Beta features
3. Check **"Enable Docker MCP Toolkit"**
4. Apply

### 2. Create a profile and add servers

**Via Docker Desktop UI (recommended):**

1. MCP Toolkit → Profiles tab → Create profile
2. Name it (e.g. `dev`)
3. Add servers from the Catalog
4. Click Create

**Via CLI:**

```bash
# Initialize the default catalog
docker mcp catalog init

# Enable servers
docker mcp server enable github-official
docker mcp server enable mcp/postgres
docker mcp server enable mcp/brave-search
```

### 3. Connect to Claude Code

**One-click (Docker Desktop UI):**

MCP Toolkit → Clients tab → click **"Connect"** next to Claude Code.

**CLI:**

```bash
claude mcp add MCP_DOCKER -s user -- docker mcp gateway run
```

The `-s user` flag makes it global (not project-specific).

**With a named profile:**

```bash
claude mcp add MCP_DOCKER -s user -- docker mcp gateway run --profile my_profile
```

### 4. Verify

```bash
claude mcp list
# Inside Claude Code:
/mcp
```

## Configuration

### settings.json snippet

Auto-created by the commands above. Lives in `~/.claude.json`:

```json
{
  "mcpServers": {
    "MCP_DOCKER": {
      "command": "docker",
      "args": ["mcp", "gateway", "run"]
    }
  }
}
```

With a profile:

```json
{
  "mcpServers": {
    "MCP_DOCKER": {
      "command": "docker",
      "args": ["mcp", "gateway", "run", "--profile", "my_profile"]
    }
  }
}
```

### Project-level `.mcp.json`

```json
{
  "mcpServers": {
    "MCP_DOCKER": {
      "command": "docker",
      "args": ["mcp", "gateway", "run"]
    }
  }
}
```

### Gateway config files

All in `~/.docker/mcp/`:

| File | Purpose |
|------|---------|
| `docker-mcp.yaml` | Server catalog definitions |
| `registry.yaml` | Which servers are enabled |
| `config.yaml` | Per-server credentials and options |
| `tools.yaml` | Per-server tool enable/disable |

## Managing servers and tools

```bash
# List enabled servers
docker mcp server ls

# Enable / disable a server
docker mcp server enable <name>
docker mcp server disable <name>

# Inspect a server's tools and config
docker mcp server inspect <name>

# List all available tools
docker mcp tools ls

# Count tools across all enabled servers
docker mcp tools count

# Test a tool directly
docker mcp tools call <tool-name> [args]
```

## Popular catalog servers

### Docker-native

| Server | Tools |
|--------|-------|
| `dockerhub` | Search images, manage repos/tags, check Hardened Images |
| `kubernetes` | Kubernetes cluster management via kubectl |

### Developer tools

| Server | What it does |
|--------|-------------|
| `github-official` | 40+ tools: repos, issues, PRs, code search |
| `mcp/postgres` | PostgreSQL query and schema |
| `mcp/redis` | Redis cache operations |
| `mcp/neo4j` | Graph database |
| `mcp/elasticsearch` | Search and analytics |
| `mcp/filesystem` | Local file operations |

### Web and search

| Server | What it does |
|--------|-------------|
| `mcp/brave-search` | Web, image, news search |
| `mcp/playwright` | Browser automation |
| `mcp/puppeteer` | Headless browser |
| `mcp/firecrawl` | Web scraping |
| `mcp/perplexity` | AI search |
| `mcp/tavily` | Research search |

### Productivity

| Server | What it does |
|--------|-------------|
| `mcp/notion` | Notion workspace |
| `mcp/slack` | Slack messaging |
| `mcp/atlassian` | Jira / Confluence |
| `mcp/google-drive` | Google Drive files |
| `mcp/obsidian` | Obsidian vault access |

### Infrastructure

| Server | What it does |
|--------|-------------|
| `mcp/heroku` | Heroku deployments |
| `mcp/grafana` | Metrics and dashboards |
| `mcp/new-relic` | Observability |
| `mcp/stripe` | Payment API |

Full catalog: https://hub.docker.com/mcp

## Credentials and OAuth

```bash
# Manage stored credentials
docker mcp secret --help

# Configure OAuth flows (GitHub, Notion, etc.)
docker mcp oauth --help

# Access control policies
docker mcp policy --help
```

Credentials are stored in `~/.docker/mcp/config.yaml` and injected into
containers at runtime.

## Platform differences

| | Mac | Windows | Linux |
|---|---|---|---|
| Plugin location | `~/.docker/cli-plugins/docker-mcp` | `%USERPROFILE%\.docker\cli-plugins\docker-mcp.exe` | `~/.docker/cli-plugins/docker-mcp` |
| Config dir | `~/.docker/mcp/` | `%USERPROFILE%\.docker\mcp\` | `~/.docker/mcp/` |
| Docker Desktop UI | Full MCP Toolkit panel | Full MCP Toolkit panel | CLI only (no Desktop GUI) |
| Command in config | `"docker"` | `"docker"` | `"docker"` |

### WSL2 notes

If running Claude Code in WSL2 with Docker Desktop on Windows:

```json
{
  "mcpServers": {
    "MCP_DOCKER": {
      "command": "docker.exe",
      "args": ["mcp", "gateway", "run"],
      "env": {
        "LOCALAPPDATA": "C:\\Users\\YOUR_USERNAME\\AppData\\Local",
        "ProgramFiles": "C:\\Program Files",
        "ProgramData": "C:\\ProgramData"
      }
    }
  }
}
```

Note `docker.exe` instead of `docker` to call the Windows-side Docker.

### Linux without Docker Desktop

If using Docker Engine without Desktop, set this to bypass the Desktop check:

```bash
export DOCKER_MCP_IN_CONTAINER=1
```

## Container security

Each MCP server runs in a container with:

- Restricted privileges (no root by default)
- 1 CPU cap, 2 GB RAM cap
- No host filesystem access unless explicitly configured
- Isolated networking

## Links

- Docs: https://docs.docker.com/ai/mcp-catalog-and-toolkit/get-started/
- Gateway docs: https://docs.docker.com/ai/mcp-catalog-and-toolkit/mcp-gateway/
- Catalog: https://hub.docker.com/mcp
- GitHub: https://github.com/docker/mcp-gateway
- Blog: https://www.docker.com/blog/add-mcp-servers-to-claude-code-with-mcp-toolkit/
