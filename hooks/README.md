# Git Hooks Security Documentation

## Overview
This repository uses SOPS-encrypted Git hooks to automatically encrypt sensitive configuration files before commits and decrypt them after merges.

## Security Features

### 1. Symlink Attack Protection
Both `pre-commit` and `post-merge` hooks verify targets are not symlinks before writing, preventing arbitrary file overwrite attacks.

### 2. Secure Key Location
Keys are discovered in this order:
1. `SOPS_AGE_KEY_FILE` environment variable (if set)
2. `~/.config/sops/age/keys.txt` (recommended)
3. `key.txt` in repository root (fallback only)

**⚠️ WARNING**: Never commit `key.txt` to version control. Add it to `.gitignore`.

### 3. Conditional Encryption
Files are only encrypted if they've been modified since last encryption, reducing unnecessary Git churn.

### 4. Error Handling
All scripts use `set -e` to exit immediately on errors, preventing partial encryption/decryption.

### 5. Merge Validation
The `post-merge` hook only runs for actual merge commits (validates `ORIG_HEAD` exists).

## Installation

Run the setup script to install hooks:
```bash
./setup-hooks.sh
```

This copies hooks from `hooks/` to `.git/hooks/` and makes them executable.

## What Gets Encrypted

- `**/.openclaw/openclaw.json` → `openclaw.enc.json`
- `**/.openclaw/workspace/*.md` → `*.enc.md` (flat files only, depth 1)

## What Doesn't Get Encrypted

- Nested repositories (e.g., `workspace/claimwise/`)
- `node_modules/`
- `.env` files (must be gitignored separately)

## Key Management

### Recommended Setup
```bash
# Create secure key location
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Set in your shell profile
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
```

### Legacy Support
If `key.txt` exists in the repository root and `SOPS_AGE_KEY_FILE` is not set, it will be used as a fallback. This is **not recommended** for production use.
