#!/bin/sh
# Setup Git Hooks
# Copies hooks from hooks/ directory to .git/hooks/ and ensures they are executable

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

# Copy pre-commit
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    cp "$HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo "✅ Installed pre-commit hook"
else
    echo "⚠️ Warning: pre-commit hook not found in $HOOKS_DIR"
fi

# Copy post-merge
if [ -f "$HOOKS_DIR/post-merge" ]; then
    cp "$HOOKS_DIR/post-merge" "$GIT_HOOKS_DIR/post-merge"
    chmod +x "$GIT_HOOKS_DIR/post-merge"
    echo "✅ Installed post-merge hook"
else
    echo "⚠️ Warning: post-merge hook not found in $HOOKS_DIR"
fi

echo "Git hooks setup complete!"
