#!/bin/sh
# Setup Git Hooks
# Copies hooks from hooks/ directory to .git/hooks/ and ensures they are executable

set -e

HOOKS_DIR="hooks"
GIT_HOOKS_DIR=".git/hooks"

echo "Installing Git hooks..."

# Check if hooks directory exists
if [ ! -d "$HOOKS_DIR" ]; then
    echo "Error: $HOOKS_DIR directory not found!"
    exit 1
fi

# Ensure .git/hooks directory exists
mkdir -p "$GIT_HOOKS_DIR"

# Copy all hooks from the hooks directory
for hook in pre-commit post-merge; do
    if [ -f "$HOOKS_DIR/$hook" ]; then
        cp "$HOOKS_DIR/$hook" "$GIT_HOOKS_DIR/$hook"
        chmod +x "$GIT_HOOKS_DIR/$hook"
        echo "✅ Installed $hook hook"
    else
        echo "⚠️ Warning: $hook hook not found in $HOOKS_DIR"
    fi
done

echo "Git hooks setup complete!"
