#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
NVIM_VERSION="${NVIM_VERSION:-v0.11.5}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Backing up existing $target to $backup"
        mv "$target" "$backup"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"

    backup_if_exists "$target"

    ln -s "$source" "$target"
    info "Created symlink: $target -> $source"
}

install_nvim() {
    info "Checking for Neovim..."
    if command -v nvim >/dev/null 2>&1; then
        local version_line
        version_line="$(nvim --version | head -n 1)"
        if [[ "$version_line" == NVIM\ v0.11.* ]]; then
            info "Neovim is already installed: $version_line"
        else
            warn "Installed Neovim is not 0.11.x: $version_line"
            warn "This config targets Neovim 0.11.x to keep plugin/API compatibility stable."
        fi
    else
        warn "Neovim not found. Installing $NVIM_VERSION..."
        
        # Download AppImage
        if curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"; then
            # Make executable
            chmod u+x nvim-linux-x86_64.appimage
            
            # Move to /usr/local/bin (requires sudo)
            info "Moving nvim AppImage to /usr/local/bin/nvim (requires sudo)..."
            if sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim; then
                 info "Neovim installed successfully."
            else
                 error "Failed to move nvim to /usr/local/bin. Please check permissions."
                 rm -f nvim-linux-x86_64.appimage
                 exit 1
            fi
        else
            error "Failed to download Neovim AppImage."
            exit 1
        fi
        
        # Verify
        if command -v nvim >/dev/null 2>&1; then
             info "Verified installation: $(nvim --version | head -n 1)"
        else
             error "Neovim installation failed or not found in PATH."
             exit 1
        fi
    fi
}

main() {
    info "Installing dev config from $SCRIPT_DIR"

    # Check and install nvim if needed
    install_nvim

    # Ensure .config directory exists
    mkdir -p "$CONFIG_DIR"

    # Install nvim config
    if [ -d "$SCRIPT_DIR/nvim" ]; then
        create_symlink "$SCRIPT_DIR/nvim" "$CONFIG_DIR/nvim"
    else
        error "nvim directory not found in $SCRIPT_DIR"
        exit 1
    fi

    # Install tmux config
    if [ -d "$SCRIPT_DIR/tmux" ]; then
        # Create tmux config dir and symlink the conf file
        mkdir -p "$CONFIG_DIR/tmux"
        create_symlink "$SCRIPT_DIR/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"
    else
        error "tmux directory not found in $SCRIPT_DIR"
        exit 1
    fi

    # Install dependencies
    info "Checking for required tools..."
    if command -v npm >/dev/null 2>&1; then
        info "npm found. Installing tree-sitter-cli globally..."
        npm install -g tree-sitter-cli
    elif command -v pnpm >/dev/null 2>&1; then
        warn "pnpm found but npm is missing. pnpm requires manual interactive approval to install tree-sitter-cli."
        pnpm add -g tree-sitter-cli
        warn "ACTION REQUIRED: Please run 'pnpm approve-builds -g' manually to complete tree-sitter installation."
    else
        warn "Neither pnpm nor npm found. Skipping tree-sitter-cli installation."
        warn "Please install nodejs and pnpm/npm to ensure full functionality."
    fi

    # Verify tree-sitter-cli installation
    if command -v tree-sitter >/dev/null 2>&1; then
        info "tree-sitter-cli installed: $(tree-sitter --version)"
    else
        warn "tree-sitter-cli not found in PATH. Treesitter parsers may fail to compile."
    fi

    info "Installation complete!"
    echo ""
    echo "Installed:"
    echo "  - nvim config -> $CONFIG_DIR/nvim"
    echo "  - tmux config -> $CONFIG_DIR/tmux/tmux.conf"
}

main "$@"
