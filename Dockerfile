FROM alpine/openclaw

# Base OpenClaw setup
USER root

# Install dependencies for Homebrew
RUN apk add --no-cache bash curl git sudo build-base

# Create a non-root user 'linuxbrew' if it doesn't exist, or use 'node' if it exists and we want to use that.
# Homebrew doesn't like running as root.
# Assuming 'alpine/openclaw' might have a user. Let's check or create one.
# For now, we'll try running as root for the install script (it will warn) or setup a user.
# Best practice: create a linuxbrew user.
RUN adduser -D -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER linuxbrew
WORKDIR /home/linuxbrew

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

WORKDIR /app
# COPY . .
# RUN npm install

CMD ["node"]
