#!/bin/sh
# Setup Git Hooks
# Copies hooks from hooks/ directory to .git/hooks/ and ensures they are executable

set -e

HOOKS_DIR="hooks"
GIT_HOOKS_DIR=".git/hooks"

echo "Installing Git hooks..."

# Check if 1Password CLI is installed
if ! command -v op &> /dev/null; then
    echo "⚠️  1Password CLI (op) not found. Please install it."
    echo "   brew install 1password-cli"
else
    # Check if signed in
    if ! op whoami &> /dev/null; then
        echo "⚠️  Please sign in to 1Password CLI: 'op signin'"
    else
         # Check for the key item
         if ! op item get "openclaw-sops-key" &> /dev/null; then
             echo "⚠️  1Password item 'openclaw-sops-key' not found."
             echo "   Please create it in your vault with the 'password' field containing the Age key."
         else
             echo "✅ 1Password integration ready."
         fi
    fi
fi

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
