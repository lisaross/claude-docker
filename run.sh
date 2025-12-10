#!/bin/bash
# Run Claude Code development container
# Usage: ./run.sh [path-to-mount]

set -e

IMAGE_NAME="claude-code-dev"
CONTAINER_NAME="claude-dev-$$"  # Unique name per session

# Default workspace mount
MOUNT_PATH="${1:-$(pwd)}"

echo "🐳 Starting Claude Code development container..."
echo "   Mounting: $MOUNT_PATH -> /home/claude/workspace"
echo ""

docker run -it --rm \
    --name "$CONTAINER_NAME" \
    -v "$MOUNT_PATH:/home/claude/workspace" \
    -e TERM=xterm-256color \
    "$IMAGE_NAME"
