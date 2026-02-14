#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"

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
        info "Neovim is already installed: $(nvim --version | head -n 1)"
    else
        warn "Neovim not found. Installing v0.11.2..."
        
        # Download AppImage
        if curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.appimage; then
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
    else
        warn "npm not found. Skipping tree-sitter-cli installation."
        warn "Please install nodejs and npm to ensure full functionality."
    fi

    info "Installation complete!"
    echo ""
    echo "Installed:"
    echo "  - nvim config -> $CONFIG_DIR/nvim"
    echo "  - tmux config -> $CONFIG_DIR/tmux/tmux.conf"
}

main "$@"