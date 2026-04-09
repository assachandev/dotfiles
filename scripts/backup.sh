#!/bin/bash

BACKUP_DIR=""

init_backup() {
    BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y-%m-%d_%H-%M-%S)"
}

backup_config() {
    local target="${1/#\~/$HOME}"

    if [ -e "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
        info "Backed up: $(basename "$target") → $BACKUP_DIR/"
    fi
}
