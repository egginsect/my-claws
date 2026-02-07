#!/bin/sh
# Setup Git Hooks
# Copies hooks from hooks/ directory to .git/hooks/ and ensures they are executable

set -e

HOOKS_DIR="hooks"
GIT_HOOKS_DIR=".git/hooks"

echo "Installing Git hooks..."

# Check if 1Password CLI is installed
echo ""
echo "Checking 1Password setup..."
if ! command -v op &> /dev/null; then
    echo "ℹ️  1Password CLI (op) not found (optional)"
    echo "   Install with: brew install 1password-cli"
    echo "   Note: You can also use SOPS_AGE_KEY env var or local key file"
else
    # Check if signed in
    if ! op whoami &> /dev/null; then
        echo "ℹ️  1Password CLI not signed in (optional)"
        echo "   You'll be prompted to sign in when running git commands"
        echo "   Or you can sign in now: op signin"
    else
         # Check for the key item
         if ! op item get "openclaw-sops-key" &> /dev/null; then
             echo "ℹ️  1Password item 'openclaw-sops-key' not found"
             echo "   Create it in the 'Develop' vault with the Age secret key in the 'password' field"
             echo "   You can also use SOPS_AGE_KEY env var or local key file as fallback"
         else
             echo "✅ 1Password integration ready!"
         fi
    fi
fi
echo ""

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
