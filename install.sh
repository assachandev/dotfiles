#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/utils.sh
source "$DOTFILES_DIR/scripts/utils.sh"
# shellcheck source=scripts/backup.sh
source "$DOTFILES_DIR/scripts/backup.sh"

# ─────────────────────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────────────────────

check_ubuntu() {
    if ! command -v apt &>/dev/null; then
        error "This script only supports Ubuntu (apt-based)."
        exit 1
    fi
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        success "Detected: $PRETTY_NAME"
    else
        success "Ubuntu (apt) detected."
    fi
}

install_pkgs() {
    sudo apt-get install -y "$@"
}

apt_update() {
    sudo apt-get update -qq
}

copy_config() {
    local src="$DOTFILES_DIR/configs/$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        warn "Config not found: configs/$1 — skipping."
        return
    fi

    backup_config "$dest"

    if [ -d "$src" ]; then
        mkdir -p "$dest"
        cp -r "$src/." "$dest/"
    else
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    fi

    success "Copied → $dest"
}

# Install a single binary from GitHub releases tarball
# Usage: install_github_binary <url> <binary_name_in_archive> <install_dest>
install_github_binary() {
    local url="$1"
    local bin_name="$2"
    local dest="${3:-/usr/local/bin/$bin_name}"
    local tmp
    tmp=$(mktemp -d)

    info "Downloading $bin_name..."
    curl -fsSL "$url" | tar -xz -C "$tmp" 2>/dev/null \
        || { curl -fsSL "$url" -o "$tmp/$bin_name.tar.gz" && tar -xz -C "$tmp" -f "$tmp/$bin_name.tar.gz"; }

    local bin_path
    bin_path=$(find "$tmp" -type f -name "$bin_name" | head -1)
    if [ -z "$bin_path" ]; then
        error "Could not find binary '$bin_name' in archive."
        rm -rf "$tmp"
        return 1
    fi

    sudo install -m 755 "$bin_path" "$dest"
    rm -rf "$tmp"
    success "$bin_name installed → $dest"
}

# ─────────────────────────────────────────────────────────────
#  Tools
# ─────────────────────────────────────────────────────────────

install_zsh() {
    ask "Install zsh?" || return
    section "zsh"
    install_pkgs zsh curl git

    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        success "Oh My Zsh already installed."
    fi

    # zsh-autosuggestions
    if [ ! -d "$HOME/.config/zsh/zsh-autosuggestions" ]; then
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.config/zsh/zsh-autosuggestions"
    else
        success "zsh-autosuggestions already installed."
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$HOME/.config/zsh/zsh-syntax-highlighting" ]; then
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.config/zsh/zsh-syntax-highlighting"
    else
        success "zsh-syntax-highlighting already installed."
    fi

    copy_config "zsh/.zshrc" "$HOME/.zshrc"
    copy_config "zsh/.p10k.zsh" "$HOME/.p10k.zsh"

    if [ "$SHELL" != "$(which zsh)" ]; then
        ask "Set zsh as default shell?" && chsh -s "$(which zsh)"
    fi
    success "zsh done."
}

install_tmux() {
    ask "Install tmux?" || return
    section "tmux"
    install_pkgs tmux
    copy_config "tmux/.tmux.conf" "$HOME/.tmux.conf"
    success "tmux done."
}

install_bat() {
    ask "Install bat?" || return
    section "bat"
    install_pkgs bat
    # On some Ubuntu versions the binary is 'batcat' — create a symlink
    if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
        info "Symlinked batcat → ~/.local/bin/bat (ensure ~/.local/bin is in PATH)"
    fi
    copy_config "bat" "$HOME/.config/bat"
    success "bat done."
}

install_btop() {
    ask "Install btop?" || return
    section "btop"
    install_pkgs btop
    copy_config "btop" "$HOME/.config/btop"
    success "btop done."
}

install_atuin() {
    ask "Install atuin?" || return
    section "atuin"
    if command -v atuin &>/dev/null; then
        success "atuin already installed."
    else
        info "Installing atuin via install script..."
        curl -fsSL https://setup.atuin.sh | bash
    fi
    copy_config "atuin/config.toml" "$HOME/.config/atuin/config.toml"
    success "atuin done."
}

install_ripgrep() {
    ask "Install ripgrep?" || return
    section "ripgrep"
    install_pkgs ripgrep
    copy_config "ripgrep/config" "$HOME/.config/ripgrep/config"
    success "ripgrep done."
}

install_zoxide() {
    if command -v zoxide &>/dev/null; then
        success "zoxide already installed."
        return
    fi
    info "Installing zoxide..."
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}

install_eza() {
    if command -v eza &>/dev/null; then
        success "eza already installed."
        return
    fi
    info "Installing eza..."
    # Try apt first (Ubuntu 24.04+)
    if apt-cache show eza &>/dev/null 2>&1; then
        install_pkgs eza
    else
        # Install from GitHub releases
        local arch
        arch=$(dpkg --print-architecture)
        local url="https://github.com/eza-community/eza/releases/latest/download/eza_${arch}-unknown-linux-musl.tar.gz"
        install_github_binary "$url" "eza"
    fi
}

install_duf() {
    if command -v duf &>/dev/null; then
        success "duf already installed."
        return
    fi
    info "Installing duf..."
    if apt-cache show duf &>/dev/null 2>&1; then
        install_pkgs duf
    else
        local arch
        arch=$(dpkg --print-architecture)
        local url="https://github.com/muesli/duf/releases/latest/download/duf_linux_${arch}.tar.gz"
        install_github_binary "$url" "duf"
    fi
}

install_cli_tools() {
    ask "Install CLI utilities (zoxide, eza, tree, duf, fzf, fd-find, zip, unzip, p7zip)?" || return
    section "CLI utilities"
    install_pkgs tree fzf fd-find zip unzip p7zip-full

    # fd-find binary is 'fdfind' — create symlink
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        info "Symlinked fdfind → ~/.local/bin/fd (ensure ~/.local/bin is in PATH)"
    fi

    install_zoxide
    install_eza
    install_duf

    success "CLI utilities done."
}

install_yazi() {
    ask "Install yazi?" || return
    section "yazi"
    if command -v yazi &>/dev/null; then
        success "yazi already installed."
    else
        info "Installing yazi from GitHub releases..."
        local tmp
        tmp=$(mktemp -d)
        local url="https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip"
        curl -fsSL "$url" -o "$tmp/yazi.zip"
        unzip -q "$tmp/yazi.zip" -d "$tmp"
        local bin_path
        bin_path=$(find "$tmp" -type f -name "yazi" | head -1)
        if [ -n "$bin_path" ]; then
            sudo install -m 755 "$bin_path" /usr/local/bin/yazi
        fi
        # Also install 'ya' if present
        local ya_path
        ya_path=$(find "$tmp" -type f -name "ya" | head -1)
        if [ -n "$ya_path" ]; then
            sudo install -m 755 "$ya_path" /usr/local/bin/ya
        fi
        rm -rf "$tmp"
    fi
    copy_config "yazi" "$HOME/.config/yazi"
    if command -v ya &>/dev/null; then
        info "Installing yazi plugins..."
        ya pack -i
    else
        warn "ya not found — run 'ya pack -i' manually to install yazi plugins."
    fi
    success "yazi done."
}

# ─────────────────────────────────────────────────────────────
#  Main
# ─────────────────────────────────────────────────────────────

main() {
    section "Dotfiles Installer (Ubuntu Server)"
    check_ubuntu
    apt_update

    init_backup
    info "Backup directory: $BACKUP_DIR"

    section "Shell & Terminal"
    install_zsh
    install_tmux

    section "CLI Tools"
    install_bat
    install_btop
    install_atuin
    install_ripgrep
    install_cli_tools
    install_yazi

    echo ""
    success "All done!"
    if [ -d "$BACKUP_DIR" ]; then
        info "Old configs backed up to: $BACKUP_DIR"
    fi
    info "Restart your terminal or run: source ~/.zshrc"
}

main "$@"
