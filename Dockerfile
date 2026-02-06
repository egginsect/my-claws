FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Install Node.js 22 (Securely)
ENV NODE_MAJOR=22
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install system dependencies for Homebrew and tooling
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential procps file git unzip && \
    rm -rf /var/lib/apt/lists/*

# Install OpenClaw/Open Cloud via npm.
RUN npm i -g openclaw && \
    npm cache clean --force && \
    command -v openclaw && \
    openclaw --version

# Setup Homebrew Directory for abc user
RUN mkdir -p /home/linuxbrew /config && \
    chown -R abc:abc /home/linuxbrew /config

# Install Homebrew, 1Password CLI, and GitHub CLI (as abc user)
USER abc
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install 1password-cli gh && \
    brew cleanup -s && \
    rm -rf "${HOME}/.cache/Homebrew" && \
    brew --version && \
    gh --version && \
    op --version

# Switch back to root for cleanup/final setup and global config
USER root
# (No global config changes to prevent leakage)

# Add Homebrew to PATH for all users (root included)
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# Create s6 service for OpenClaw gateway (runs at container boot)
# Also handles fixing /config permissions and user bashrc setup
RUN mkdir -p /etc/s6-overlay/s6-rc.d/openclaw-gateway/dependencies.d && \
    touch /etc/s6-overlay/s6-rc.d/openclaw-gateway/dependencies.d/init-adduser
RUN cat > /etc/s6-overlay/s6-rc.d/openclaw-gateway/run <<'EOF'
#!/usr/bin/with-contenv bash
# Fix permissions for entire /config directory (abc home)
chown -R abc:abc /config
# Ensure brew in .bashrc (with UID check for shared home)
if [ -f /config/.bashrc ]; then
  # Remove old unsafe line if present (legacy fix cleanup)
  sed -i "/eval.*brew shellenv.*/d" /config/.bashrc
  # Append secure line
  if ! grep -q "brew shellenv" /config/.bashrc; then
    echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> /config/.bashrc
  fi
fi
unset DISPLAY
exec openclaw gateway --allow-unconfigured --bind lan --port ${OPENCLAW_PORT:-18789}
EOF
RUN chmod +x /etc/s6-overlay/s6-rc.d/openclaw-gateway/run && \
    echo "longrun" > /etc/s6-overlay/s6-rc.d/openclaw-gateway/type && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/openclaw-gateway
