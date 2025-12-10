# Claude Code Development Container
# Minimal Debian-based image with Claude Code CLI for plugin testing

FROM debian:bookworm-slim

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Shell
    zsh \
    # Version control
    git \
    # Network tools for Claude install
    curl \
    ca-certificates \
    # Node.js requirements (for npx/MCP)
    nodejs \
    npm \
    # Useful utilities
    jq \
    # Clean up apt cache to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
ARG USERNAME=claude
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/zsh $USERNAME \
    && mkdir -p /home/$USERNAME/.claude \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME

# Switch to non-root user
USER $USERNAME
WORKDIR /home/$USERNAME

# Set up zsh as default shell
ENV SHELL=/bin/zsh
ENV HOME=/home/$USERNAME

# Copy zsh configuration
COPY --chown=$USERNAME:$USERNAME .zshrc /home/$USERNAME/.zshrc

# Auto-switch to zsh from any shell
RUN echo '[ -t 0 ] && [ "$0" != "zsh" ] && command -v zsh > /dev/null && exec zsh' >> /home/$USERNAME/.profile \
    && echo '[ -t 0 ] && [ "$0" != "zsh" ] && command -v zsh > /dev/null && exec zsh' >> /home/$USERNAME/.bashrc

# Install Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash -s latest

# Add Claude to PATH
ENV PATH="/home/$USERNAME/.local/bin:$PATH"

# Create workspace directory
RUN mkdir -p /home/$USERNAME/workspace

# Copy entrypoint script
COPY --chown=$USERNAME:$USERNAME entrypoint.sh /home/$USERNAME/entrypoint.sh
RUN chmod +x /home/$USERNAME/entrypoint.sh

WORKDIR /home/$USERNAME/workspace

# Run entrypoint (clones demo project, then stays alive)
CMD ["/home/claude/entrypoint.sh"]
