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
2.  Populate `.openclaw/` with your configuration files.
3.  Edit `.env` to set your `OPENCLAW_GATEWAY_TOKEN`.
4.  Start the agent:
    ```bash
    docker-compose up -d
    ```
