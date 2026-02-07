# My Claws

This repository manages multiple OpenClaw agent instances.

## Structure

Each agent has its own directory (e.g., `agent-01`) containing:
-   `docker-compose.yml`: Defines the agent service.
-   `.openclaw/`: Directory for OpenClaw configuration files.
-   `.env.example`: Template for environment variables.

## Getting Started

1.  Copy `.env.example` to `.env` in the agent directory.
    ```bash
    cd agent-01
    cp .env.example .env
    ```
2.  Edit `.env` to set your `OPENCLAW_GATEWAY_TOKEN`.
3.  Start the agent:
    ```bash
    docker-compose up -d
    ```

## Configuration Management with SOPS

This repository uses [SOPS](https://github.com/getsops/sops) to encrypt configuration files. We use **1Password** to securely manage the decryption key.

### Prerequisites

1.  **Install tools**:
    ```bash
    brew install sops 1password-cli
    ```
2.  **Sign in to 1Password CLI**:
    ```bash
    op signin
    ```
3.  **Create the Key Item**:
    Ensure you have access to the shared item **`openclaw-sops-key`** in the **`Develop`** vault.
    -   Item Name: `openclaw-sops-key`
    -   Vault: `Develop`
    -   Field: `password` (Must contain the Age secret key starting with `AGE-SECRET-KEY-...`)

### Git Hooks Setup

After cloning, run the setup script to configure git hooks. These hooks automatically fetch the key from 1Password to encrypt/decrypt files seamlessly.

```bash
./setup-hooks.sh
```

### How it Works

-   **`pre-commit`**: Encrypts `*.json` files to `*.enc.json` before committing.
-   **`post-merge` / `post-checkout`**: Decrypts `*.enc.json` files to `*.json` after pulling or switching branches.
    -   If you have local changes, it attempts to merge them safely.
    -   If there is a conflict, standard git conflict markers (`<<<<<<<`) are inserted for you to resolve.

## Post-Clone Setup (Important)

To ensure secure handling of encrypted files, please configure git hooks immediately after cloning:

```bash
./setup-hooks.sh
```

This sets up automatic encryption/decryption and conflict resolution for configuration files.
dummy change
