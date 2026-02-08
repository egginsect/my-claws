FROM alpine/openclaw:main

USER root

# Keep extra tooling from the previous image without adding GUI dependencies.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates gnupg git jq gh && \
    ARCH="$(dpkg --print-architecture)" && \
    if [ "${ARCH}" != "arm64" ]; then \
      echo "Unsupported architecture: ${ARCH}. This image is arm64-only." >&2; \
      exit 1; \
    fi && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor -o /etc/apt/keyrings/1password.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/1password.gpg] https://downloads.1password.com/linux/debian/arm64 stable main" > /etc/apt/sources.list.d/1password.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends 1password-cli && \
    npm install -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli && \
    ln -sf /app/openclaw.mjs /usr/local/bin/openclaw && \
    npm cache clean --force && \
    rm -rf /var/lib/apt/lists/*

USER 1000:1000

# Headless gateway runtime only.
CMD ["sh", "-lc", "exec openclaw gateway --allow-unconfigured --bind lan --port ${OPENCLAW_PORT:-18789}"]
