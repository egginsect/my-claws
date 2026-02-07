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

# Configure git to use the hooks directory directly
# This means updates to hooks/ are immediately active without copying
git config core.hooksPath "$HOOKS_DIR"

# Ensure hooks are executable
chmod +x "$HOOKS_DIR/pre-commit" "$HOOKS_DIR/post-merge" "$HOOKS_DIR/post-checkout"

echo "✅ Git hooks configured to use ./$HOOKS_DIR"

echo "Git hooks setup complete!"
