# Claude Code Plugin Development Container

A clean, isolated Docker environment for developing and testing [Claude Code plugins](https://docs.anthropic.com/en/docs/claude-code/plugins). Each session starts fresh—perfect for testing plugins without state pollution from previous installations.

## Features

- **Clean slate testing** - No persisted auth, config, or plugin state between sessions
- **Demo project included** - TypeScript React todo app auto-clones on startup for testing
- **Plugin-ready** - Node.js, npm, npx pre-installed for plugin dependencies
- **Skip permissions mode** - `cc` alias runs Claude with `--dangerously-skip-permissions` for faster testing
- **zsh configured** - Helpful aliases and git-aware prompt

## Quick Start

```bash
# Build the image
docker build -t claude-code-dev .

# Start the container
docker-compose up -d

# Connect (type 'zsh' first if using Docker Desktop terminal)
docker exec -it claude-dev zsh

# Start Claude Code and authenticate
claude
```

## Plugin Development Workflow

### 1. Start a fresh container

```bash
docker-compose up -d
docker exec -it claude-dev zsh
```

### 2. Authenticate Claude Code

```bash
claude
# Follow the browser auth flow
```

### 3. Install your plugin marketplace

Inside Claude Code:
```
/plugin install <your-marketplace-url>
```

### 4. Install and test plugins

```
/plugin list
/plugin install <plugin-name>
```

### 5. Test against the demo project

The container includes a TypeScript React todo app at `~/workspace/demo-todo/`:

```bash
cd ~/workspace/demo-todo
cc  # Start Claude with --dangerously-skip-permissions
```

### 6. Reset for clean testing

```bash
# From host - destroys all state
docker-compose down
docker-compose up -d
```

## Plugin Components You Can Test

Claude Code plugins can include:

- **Commands** - Custom slash commands (`/mycommand`)
- **Agents** - Specialized AI agents for specific tasks  
- **Skills** - Reusable capabilities for agents
- **Hooks** - Lifecycle event handlers (PreToolUse, PostToolUse, etc.)
- **MCP Servers** - Model Context Protocol integrations

See the [Plugins Reference](https://docs.anthropic.com/en/docs/claude-code/plugins-reference) for full documentation.

## Shell Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `cc` | `claude --dangerously-skip-permissions` | Fast testing mode |
| `ccc` | `claude --continue` | Continue last session |
| `mcp-list` | `claude mcp list` | List MCP servers |
| `mcp-add` | `claude mcp add` | Add MCP server |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEMO_REPO` | `https://github.com/nas5w/react-typescript-todo-app` | Demo project to clone on startup |

Override in `docker-compose.yml` to use a different demo project.

## Directory Structure

```
claude-docker/
├── Dockerfile          # Container definition
├── docker-compose.yml  # Compose configuration  
├── entrypoint.sh       # Startup script (clones demo project)
├── .zshrc              # Shell configuration
├── run.sh              # Quick run script
└── workspace/          # Mounted workspace (persists on host)
    └── demo-todo/      # Auto-cloned demo project
```

## Included Packages

- **Claude Code CLI** - Pre-installed via official installer
- **Node.js + npm** - For plugins and MCP servers
- **git** - Version control
- **zsh** - Shell with config
- **curl, jq** - Utilities

## Tips

- **Docker Desktop terminal** uses `sh` by default—type `zsh` to get aliases
- **Authentication required** on each fresh container start
- **Container runs as** non-root user `claude` (UID 1000)
- **Demo project** won't re-clone if `workspace/demo-todo/` exists on host
- **Watch startup progress** with `docker logs -f claude-dev`

## Troubleshooting

**`cc` command not found**  
You're in `sh`, not `zsh`. Type `zsh` first.

**Plugin not loading**  
Check `/plugin list` to verify installation. Try `/plugin reload`.

**Need completely fresh state**  
```bash
docker-compose down
rm -rf workspace/demo-todo  # Also reset demo project
docker-compose up -d
```
