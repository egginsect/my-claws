FROM alpine/openclaw:latest

# Switch to root to install system dependencies and Homebrew
USER root

# Install dependencies needed for Homebrew and sudo
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    procps \
    curl \
    file \
    git \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Give node user passwordless sudo for Homebrew installation
RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to node user to install Homebrew (Homebrew refuses to run as root)
USER node
WORKDIR /home/node

# Install Homebrew
ENV NONINTERACTIVE=1
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH for all users
USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Create alias for 'openclaw' command to run 'node dist/index.js'
RUN echo '#!/bin/sh' > /usr/local/bin/openclaw && \
    echo 'exec node /app/dist/index.js "$@"' >> /usr/local/bin/openclaw && \
    chmod +x /usr/local/bin/openclaw

# Switch back to node user for security
USER node

# Set working directory
WORKDIR /app

# Default command is handled by the base image



