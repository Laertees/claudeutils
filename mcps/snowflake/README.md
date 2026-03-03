# Snowflake MCP Server (snowflake-labs-mcp)

Query Snowflake, use Cortex Analyst for natural-language BI questions over semantic
views, search Cortex Search services, and manage semantic models — all from Claude Code.

## What it provides

| Tool | Description |
|------|-------------|
| `run_snowflake_query` | Execute SQL queries (SELECT, DESCRIBE, SHOW, USE, etc.) |
| `cortex_analyst` | Natural-language questions against Cortex Analyst semantic views |
| `cortex_search` | Search Cortex Search services (knowledge bases, docs) |
| `list_semantic_views` | List available semantic views in a database/schema |
| `semantic_manager` | Inspect and manage semantic model definitions |
| `query_manager` | Query history and management |

## Prerequisites

- Python 3.10+ with `uvx` (or `pip`)
- A Snowflake account with connection configured via `snow` CLI
- Cortex Analyst semantic views (for the analyst tool)
- Cortex Search services (for the search tool, optional)

## Setup

### 1. Configure a Snowflake connection

The MCP server uses `snow` CLI connection profiles stored in `~/.snowflake/connections.toml`.

```bash
# Install Snowflake CLI if needed
pip install snowflake-cli

# Add a connection
snow connection add
```

Example `~/.snowflake/connections.toml` entry:

```toml
[my_connection]
account = "orgid-accountname"
user = "MYUSER"
authenticator = "externalbrowser"   # SSO, or use password/key-pair
warehouse = "COMPUTE_WH"
database = "MY_DATABASE"
schema = "MY_SCHEMA"
role = "MY_ROLE"
```

**Important:** Use hyphens (not underscores) in the account identifier.
Underscores cause SSL cert mismatch errors on the Cortex REST API.

### 2. Create the service config

Create a YAML file defining which Cortex services to expose:

```yaml
# config/mcp_server_config.yaml

analyst_services:
  - service_name: my_analyst
    semantic_model: MY_DB.MY_SCHEMA.MY_SEMANTIC_VIEW
    description: >
      Description of what this analyst covers.

search_services:
  - service_name: MY_SEARCH_SERVICE
    description: >
      Search help docs and knowledge base
    database_name: MY_DB
    schema_name: MY_SCHEMA

other_services:
  object_manager: False
  query_manager: True
  semantic_manager: True

sql_statement_permissions:
  - Select: True
  - Describe: True
  - Command: True      # needed for SHOW/USE statements
  - Use: True
  - All: False          # keep False for read-only access
```

### 3. Register with Claude Code

**Via `.mcp.json` (project-level, recommended):**

```json
{
  "mcpServers": {
    "snowflake": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "snowflake-labs-mcp",
        "--service-config-file",
        "/absolute/path/to/mcp_server_config.yaml",
        "--connection-name",
        "my_connection"
      ],
      "env": {}
    }
  }
}
```

**Via CLI:**

```bash
claude mcp add snowflake -s project -- \
  uvx snowflake-labs-mcp \
  --service-config-file /absolute/path/to/mcp_server_config.yaml \
  --connection-name my_connection
```

**Global (user-level):**

```bash
claude mcp add snowflake -s user -- \
  uvx snowflake-labs-mcp \
  --service-config-file /absolute/path/to/mcp_server_config.yaml \
  --connection-name my_connection
```

### 4. Verify

```bash
# Check it's registered
claude mcp list

# Inside Claude Code
/mcp
```

Then try: "Run SELECT CURRENT_USER()" to confirm the connection works.

## Authentication methods

Configured in `~/.snowflake/connections.toml`:

| Method | `authenticator` value | Notes |
|--------|-----------------------|-------|
| SSO / browser | `externalbrowser` | Opens browser for login, good for dev |
| Password | (omit authenticator) | Set `password` field |
| Key-pair | `SNOWFLAKE_JWT` | Set `private_key_path`, no password needed |
| OAuth | `oauth` | Set `token` field |

For CI/automated use, key-pair (`SNOWFLAKE_JWT`) is recommended.

## Service config reference

### `analyst_services`

Each entry creates a Cortex Analyst tool backed by a semantic view:

```yaml
analyst_services:
  - service_name: casino_analyst
    semantic_model: DBT_DEV.SECURE.MART_CASINO_BY_TIME_SV
    description: >
      Casino betting metrics by time, game, and demographic.
```

- `semantic_model` is the fully qualified path: `DATABASE.SCHEMA.SEMANTIC_VIEW`
- Do **not** prefix with `@` (that's only for YAML files on stages)

### `search_services`

Each entry connects to a Cortex Search service:

```yaml
search_services:
  - service_name: DOCS_SEARCH_SERVICE
    description: >
      Search documentation
    database_name: MY_DB
    schema_name: MY_SCHEMA
```

- `service_name` must match the exact Snowflake service name (case-sensitive)

### `other_services`

```yaml
other_services:
  object_manager: False    # browse database objects
  query_manager: True      # query history/management
  semantic_manager: True   # inspect semantic models
```

### `sql_statement_permissions`

Controls which SQL statement types are allowed:

```yaml
sql_statement_permissions:
  - Select: True
  - Describe: True
  - Command: True    # SHOW, USE, CALL, etc.
  - Use: True
  - All: False       # keep False unless you need DDL/DML
```

## Troubleshooting

Common issues encountered during setup:

| Problem | Cause | Fix |
|---------|-------|-----|
| SSL cert mismatch on Cortex API | Underscore in account identifier | Use hyphens: `orgid-account-name` not `orgid-account_name` |
| Warehouse not found | Wrong warehouse name in connection | Check with `SHOW WAREHOUSES` |
| Semantic model syntax error | `@` prefix on semantic view path | Remove `@` — use `DB.SCHEMA.VIEW` |
| Semantic views not found | Wrong database/schema | Point to the schema containing your semantic views |
| Cortex Search 404 | Wrong service name | Service name is case-sensitive, must match exactly |
| SHOW commands blocked | Missing SQL permission | Add `Command: True` to `sql_statement_permissions` |
| `uvx` not found | uv not installed | `pip install uv` or `brew install uv` |

## Platform differences

| | Mac / Linux | Windows |
|---|---|---|
| Install | `uvx snowflake-labs-mcp` | Same (needs Python + uv in PATH) |
| Connection config | `~/.snowflake/connections.toml` | `%USERPROFILE%\.snowflake\connections.toml` |
| Config path in `.mcp.json` | `/Users/name/path/to/config.yaml` | `C:\\Users\\name\\path\\to\\config.yaml` |
| SSO auth | Opens default browser | Opens default browser |
| Key-pair auth | Works natively | Works natively |

The config path in `.mcp.json` must be absolute and platform-specific. For
cross-platform projects, each developer sets their own path or uses a
machine-local `.mcp.json` override.

## Links

- PyPI: https://pypi.org/project/snowflake-labs-mcp/
- GitHub: https://github.com/Snowflake-Labs/mcp
- Cortex Analyst docs: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst
- Cortex Search docs: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search
- Snow CLI: https://docs.snowflake.com/en/developer-guide/snowflake-cli
