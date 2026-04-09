#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC}    $1"; }
success() { echo -e "${GREEN}[OK]${NC}      $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}    $1"; }
error()   { echo -e "${RED}[ERROR]${NC}   $1"; }
section() { echo -e "\n${BOLD}${CYAN}── $1 ──────────────────────────────${NC}"; }

ask() {
    local prompt="$1"
    local response
    echo -en "${YELLOW}[?]${NC} ${prompt} [y/N] "
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}
