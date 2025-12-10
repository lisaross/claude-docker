#!/bin/bash
# Entrypoint script for Claude Code dev container

DEMO_REPO="${DEMO_REPO:-https://github.com/nas5w/react-typescript-todo-app}"
DEMO_DIR="/home/claude/workspace/demo-todo"

# Progress indicator
progress() {
    local msg="$1"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $msg"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Clone demo project if workspace is empty or demo doesn't exist
if [ ! -d "$DEMO_DIR" ]; then
    progress "🚀 Setting up Claude Code dev environment"
    
    echo ""
    echo "[1/3] 📦 Cloning demo project..."
    echo "      $DEMO_REPO"
    if git clone --progress "$DEMO_REPO" "$DEMO_DIR" 2>&1; then
        echo "      ✓ Clone complete"
    else
        echo "      ⚠️  Could not clone demo repo"
    fi
    
    if [ -d "$DEMO_DIR" ]; then
        cd "$DEMO_DIR"
        
        echo ""
        echo "[2/3] 📥 Installing dependencies..."
        if npm install 2>&1 | tail -5; then
            echo "      ✓ Dependencies installed"
        else
            echo "      ⚠️  npm install had issues"
        fi
        
        echo ""
        echo "[3/3] ✅ Setup complete!"
        echo ""
        echo "      Demo project: $DEMO_DIR"
        echo "      Run 'cc' to start Claude Code"
        echo ""
    fi
else
    echo "✓ Demo project already exists at $DEMO_DIR"
fi

# Keep container running
exec tail -f /dev/null
