FROM alpine/openclaw:main

USER root

ARG CLAUDE_CODE_VERSION=2.1.37
ARG CODEX_VERSION=0.98.0
ARG GEMINI_CLI_VERSION=0.27.3
ARG AGENT_BROWSER_VERSION=0.9.1
ARG PLAYWRIGHT_VERSION=1.58.2

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Keep extra tooling from the previous image without adding GUI dependencies.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates gnupg git jq gh \
      libnspr4 libnss3 libatk1.0-0 libatk-bridge2.0-0 libdbus-1-3 libcups2 \
      libxkbcommon0 libatspi2.0-0 libxcomposite1 libxdamage1 libxfixes3 \
      libxrandr2 libgbm1 libasound2 && \
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
    rm -rf /var/lib/apt/lists/*

# CLI install layer
RUN npm install -g \
      @anthropic-ai/claude-code@"${CLAUDE_CODE_VERSION}" \
      @openai/codex@"${CODEX_VERSION}" \
      @google/gemini-cli@"${GEMINI_CLI_VERSION}" \
      agent-browser@"${AGENT_BROWSER_VERSION}" \
      playwright@"${PLAYWRIGHT_VERSION}" && \
    npm cache clean --force

# Heavy browser download layer (cache this unless agent-browser version changes)
RUN agent-browser install && \
    chmod -R a+rX "${PLAYWRIGHT_BROWSERS_PATH}"

RUN ln -sf /app/openclaw.mjs /usr/local/bin/openclaw

USER 1000:1000

# Headless gateway runtime only.
CMD ["sh", "-lc", "exec openclaw gateway --allow-unconfigured --bind lan --port ${OPENCLAW_PORT:-18789}"]
