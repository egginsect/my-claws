# Stage 1: Get pre-built OpenClaw
FROM alpine/openclaw:latest AS openclaw

# Stage 2: Webtop with OpenClaw
FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# Install Node.js 22
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
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
