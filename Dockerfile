# Stage 1: Get pre-built OpenClaw
FROM alpine/openclaw:latest AS openclaw

# Stage 2: Webtop with OpenClaw
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

# Install Homebrew and 1Password CLI
# We use a dedicated linuxbrew user for installation but keep root as the main user
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential procps file git unzip && \
    useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    su - linuxbrew -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' && \
    su - linuxbrew -c 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install 1password-cli' && \
    ln -sf /home/linuxbrew/.linuxbrew/bin/op /usr/local/bin/op && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /etc/profile.d/homebrew.sh && \
    chmod +x /etc/profile.d/homebrew.sh && \
    rm -rf /var/lib/apt/lists/*

# Copy OpenClaw from builder stage
COPY --from=openclaw /app /app

# Create openclaw command wrapper
RUN echo '#!/bin/sh\nexec node /app/dist/index.js "$@"' > /usr/local/bin/openclaw && \
    chmod +x /usr/local/bin/openclaw

# Create s6 service for OpenClaw gateway (runs at container boot)
RUN mkdir -p /etc/s6-overlay/s6-rc.d/openclaw-gateway && \
    echo '#!/usr/bin/with-contenv bash\nexec /usr/local/bin/openclaw gateway --allow-unconfigured --bind lan' \
    > /etc/s6-overlay/s6-rc.d/openclaw-gateway/run && \
    chmod +x /etc/s6-overlay/s6-rc.d/openclaw-gateway/run && \
    echo "longrun" > /etc/s6-overlay/s6-rc.d/openclaw-gateway/type && \
    touch /etc/s6-overlay/s6-rc.d/user/contents.d/openclaw-gateway

# Fix: Create /defaults/pid to allow Selkies streaming to start
RUN mkdir -p /defaults && echo "1" > /defaults/pid
