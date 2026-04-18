#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=scripts/utils.sh
source "$DOTFILES_DIR/scripts/utils.sh"
# shellcheck source=scripts/backup.sh
source "$DOTFILES_DIR/scripts/backup.sh"

# ─────────────────────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────────────────────

check_arch() {
    if ! command -v pacman &>/dev/null; then
        error "This script only supports Arch Linux."
        exit 1
    fi
    success "Arch Linux detected."
}

install_pkgs() {
    paru -S --needed --noconfirm "$@"
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

# ─────────────────────────────────────────────────────────────
#  AUR Helpers
# ─────────────────────────────────────────────────────────────

install_yay() {
    if command -v yay &>/dev/null; then
        success "yay already installed."
        return
    fi
    section "Installing yay"
    sudo pacman -S --needed --noconfirm git base-devel
    local tmp
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    (cd "$tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    success "yay installed."
}

install_paru() {
    if command -v paru &>/dev/null; then
        success "paru already installed."
        return
    fi
    section "Installing paru"
    local tmp
    tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$tmp/paru"
    (cd "$tmp/paru" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    success "paru installed."
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

install_kitty() {
    ask "Install kitty?" || return
    section "kitty"
    install_pkgs kitty
    copy_config "kitty" "$HOME/.config/kitty"
    success "kitty done."
}

install_yazi() {
    ask "Install yazi?" || return
    section "yazi"
    install_pkgs yazi
    copy_config "yazi" "$HOME/.config/yazi"
    if command -v ya &>/dev/null; then
        info "Installing yazi plugins..."
        ya pack -i
    else
        warn "ya not found — run 'ya pack -i' manually to install yazi plugins."
    fi
    success "yazi done."
}

install_bat() {
    ask "Install bat?" || return
    section "bat"
    install_pkgs bat
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
    install_pkgs atuin
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

install_cli_tools() {
    ask "Install CLI utilities (zoxide, eza, tree, duf, fzf, fd, zip, unzip, unrar, p7zip)?" || return
    section "CLI utilities"
    install_pkgs zoxide eza tree duf fzf fd zip unzip unrar p7zip
    success "CLI utilities done."
}

install_mpd() {
    ask "Install MPD?" || return
    section "MPD"
    install_pkgs mpd mpc
    copy_config "mpd/mpd.conf" "$HOME/.config/mpd/mpd.conf"
    mkdir -p "$HOME/.config/mpd/playlists"
    mkdir -p "$HOME/.local/state/mpd"
    ask "Enable MPD systemd user service?" && systemctl --user enable --now mpd
    success "MPD done."
}

install_rmpc() {
    ask "Install rmpc?" || return
    section "rmpc"
    install_pkgs rmpc
    copy_config "rmpc" "$HOME/.config/rmpc"
    success "rmpc done."
}

install_nvim() {
    ask "Install neovim?" || return
    section "neovim"
    install_pkgs neovim
    success "neovim done."
}

install_ytdlp() {
    ask "Install yt-dlp?" || return
    section "yt-dlp"
    install_pkgs yt-dlp
    copy_config "yt-dlp/config" "$HOME/.config/yt-dlp/config"
    success "yt-dlp done."
}

install_ytx() {
    ask "Install yt-x?" || return
    section "yt-x"
    install_pkgs mpv fzf yt-x
    copy_config "yt-x" "$HOME/.config/yt-x"
    success "yt-x done."
}

install_apps() {
    ask "Install GUI applications (Firefox, Telegram, Slack, Signal, FileZilla, TigerVNC, VLC, LibreOffice, Zathura)?" || return
    section "Applications"
    install_pkgs firefox telegram-desktop signal-desktop filezilla tigervnc vlc libreoffice-fresh
    install_pkgs slack-desktop
    install_pkgs zathura zathura-pdf-mupdf
    success "Applications done."
}

install_scripts() {
    ask "Install custom scripts (dl.sh → ~/Music/)?" || return
    section "Custom scripts"
    mkdir -p "$HOME/Music"
    backup_config "$HOME/Music/dl.sh"
    cp "$DOTFILES_DIR/configs/scripts/dl.sh" "$HOME/Music/dl.sh"
    chmod +x "$HOME/Music/dl.sh"
    success "dl.sh → ~/Music/dl.sh"
}

# ─────────────────────────────────────────────────────────────
#  Main
# ─────────────────────────────────────────────────────────────

main() {
    section "Dotfiles Installer"
    check_arch

    section "AUR Helpers"
    install_yay
    install_paru

    init_backup
    info "Backup directory: $BACKUP_DIR"

    section "Shell & Terminal"
    install_zsh
    install_tmux
    install_kitty

    section "CLI Tools"
    install_bat
    install_btop
    install_atuin
    install_ripgrep
    install_cli_tools
    install_yazi

    section "Music"
    install_mpd
    install_rmpc

    section "Media"
    install_nvim
    install_ytdlp
    install_ytx

    section "Applications"
    install_apps

    section "Custom Scripts"
    install_scripts

    echo ""
    success "All done!"
    if [ -d "$BACKUP_DIR" ]; then
        info "Old configs backed up to: $BACKUP_DIR"
    fi
    info "Restart your terminal or run: source ~/.zshrc"
}

main "$@"
