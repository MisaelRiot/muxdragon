#!/usr/bin/env bash
set -euo pipefail

TMUX_CONFIG_DIR="$HOME/.config/tmux"
TPM_DIR="$TMUX_CONFIG_DIR/plugins/tpm"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- helpers ---

info() { printf '\033[1;34m[INFO]\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$1"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$1"; exit 1; }

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|linuxmint|pop) echo "debian" ;;
            arch|manjaro|endeavouros|garuda) echo "arch" ;;
            *)
                # check ID_LIKE as fallback
                case "${ID_LIKE:-}" in
                    *debian*|*ubuntu*) echo "debian" ;;
                    *arch*) echo "arch" ;;
                    *) echo "unknown" ;;
                esac
                ;;
        esac
    else
        echo "unknown"
    fi
}

# --- package installation ---

install_packages_debian() {
    info "Detected Debian/Ubuntu-based distribution"
    info "Updating package lists..."
    sudo apt-get update -qq
    info "Installing tmux and git..."
    sudo apt-get install -y -qq tmux git
}

install_packages_arch() {
    info "Detected Arch-based distribution"
    info "Synchronizing package databases..."
    sudo pacman -Sy --noconfirm
    info "Installing tmux and git..."
    sudo pacman -S --noconfirm --needed tmux git
}

# --- setup ---

install_packages() {
    local distro
    distro="$(detect_distro)"

    case "$distro" in
        debian) install_packages_debian ;;
        arch)   install_packages_arch ;;
        *)      error "Unsupported distribution. Install tmux and git manually, then re-run this script." ;;
    esac
}

setup_symlink() {
    local src="$SCRIPT_DIR/.tmux.conf"
    local dest="$TMUX_CONFIG_DIR/.tmux.conf"

    if [ ! -f "$src" ]; then
        error ".tmux.conf not found in $SCRIPT_DIR"
    fi

    mkdir -p "$TMUX_CONFIG_DIR"

    if [ -L "$dest" ]; then
        info "Removing existing symlink at $dest"
        rm "$dest"
    elif [ -f "$dest" ]; then
        warn "Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -s "$src" "$dest"
    info "Symlinked $src -> $dest"
}

setup_tpm() {
    if [ -d "$TPM_DIR" ]; then
        info "TPM already installed at $TPM_DIR"
    else
        info "Cloning TPM..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
}

install_plugins() {
    if [ -x "$TPM_DIR/bin/install_plugins" ]; then
        info "Installing tmux plugins via TPM..."
        "$TPM_DIR/bin/install_plugins"
    else
        warn "TPM install script not found. Start tmux and press prefix + I to install plugins manually."
    fi
}

# --- main ---

main() {
    info "Starting tmux configuration setup..."
    echo

    install_packages
    echo

    setup_symlink
    echo

    setup_tpm
    install_plugins
    echo

    info "Setup complete!"
    info "Start a new tmux session with: tmux new-session"
}

main
