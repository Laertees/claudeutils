# Claude in Chrome

Browser automation MCP that lets Claude Code interact with Chrome: click elements,
fill forms, read pages, take screenshots, record GIFs, and run JavaScript in the browser.

## Prerequisites

- Google Chrome or Microsoft Edge
- Claude Code >= 2.0.73 (`claude --version`)
- Direct Anthropic plan (Pro, Max, Teams, or Enterprise)
- **Not** available via Bedrock, Vertex AI, or other third-party providers
- **Not** supported: Brave, Arc, or other Chromium browsers

## Installation

### 1. Install the Chrome extension

Chrome Web Store:
https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn

Works in both Chrome and Edge.

### 2. Enable in Claude Code

One-time enable (current session only):

```bash
claude --chrome
```

Or from within a session:

```
/chrome
```

To enable by default (recommended): run `/chrome` and select **"Enabled by default"**.

### 3. Restart Chrome

On first enable, Claude Code installs a native messaging host config file.
Chrome must be restarted to pick it up.

## Configuration

This is a **built-in first-party MCP** - no manual `settings.json` entry needed.
Claude Code manages it automatically via `--chrome` or `/chrome`.

To verify it's connected:

```
/mcp
```

Select `claude-in-chrome` from the list.

## Native messaging host locations

The native messaging host config is installed automatically. These paths are
useful for debugging if the connection fails.

### Mac

```
# Chrome
~/Library/Application Support/Google/Chrome/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json

# Edge
~/Library/Application Support/Microsoft Edge/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json
```

### Windows

Stored in the registry (not a file):

```
# Chrome
HKCU\Software\Google\Chrome\NativeMessagingHosts\

# Edge
HKCU\Software\Microsoft\Edge\NativeMessagingHosts\
```

### Linux

```
# Chrome
~/.config/google-chrome/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json

# Edge
~/.config/microsoft-edge/NativeMessagingHosts/com.anthropic.claude_code_browser_extension.json
```

## Available tools

Once connected, these MCP tools become available:

| Tool | Purpose |
|------|---------|
| `tabs_context_mcp` | Get current tab group info (call first) |
| `tabs_create_mcp` | Create a new tab |
| `navigate` | Go to URL, back/forward |
| `read_page` | Accessibility tree of page elements |
| `find` | Natural language element search |
| `computer` | Mouse/keyboard actions, screenshots |
| `javascript_tool` | Execute JS in page context |
| `form_input` | Set form field values |
| `get_page_text` | Extract text content from page |
| `read_console_messages` | Read browser console output |
| `read_network_requests` | Monitor XHR/fetch requests |
| `gif_creator` | Record and export browser sessions as GIF |
| `upload_image` | Upload image to file input or drag target |
| `resize_window` | Set browser window dimensions |
| `shortcuts_list` | List available shortcuts/workflows |
| `shortcuts_execute` | Run a shortcut or workflow |
| `switch_browser` | Connect to a different Chrome instance |
| `update_plan` | Present action plan for user approval |

## Typical workflow

```
1. tabs_context_mcp          → discover existing tabs
2. tabs_create_mcp            → open a new tab
3. navigate                   → go to URL
4. read_page / find           → understand page structure
5. computer (screenshot)      → see what the page looks like
6. computer (left_click/type) → interact with elements
7. form_input                 → fill form fields
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "Chrome extension not detected" | Restart Chrome after first install; check `chrome://extensions` |
| "Browser extension is not connected" | Restart Chrome + Claude Code, run `/chrome` → Reconnect |
| "Receiving end does not exist" | Extension service worker went idle; `/chrome` → Reconnect |
| Connection drops in long sessions | Service worker idle; `/chrome` → Reconnect |
| Windows `EADDRINUSE` | Close other Claude Code sessions using Chrome, restart |

## Platform differences

| | Mac | Windows |
|---|---|---|
| Config location | File in `~/Library/Application Support/` | Registry key in `HKCU\Software\` |
| Activation | `claude --chrome` or `/chrome` | Same |
| WSL | N/A | **Not supported** - must run Claude Code natively |
| Named pipes | Unix socket | Named pipe (can conflict across sessions) |

## Links

- Docs: https://code.claude.com/docs/en/chrome
- MCP docs: https://code.claude.com/docs/en/mcp
