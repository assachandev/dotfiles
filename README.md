# dotfiles

My personal Arch Linux dotfiles — clone and run the install script to set up a new machine.

## Quick Start

```bash
git clone https://github.com/assachandev/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

> Arch Linux only. The script will exit if `pacman` is not found.

## What It Does

1. Installs **yay** and **paru** (AUR helpers)
2. Interactively asks before installing each tool
3. Backs up any existing configs to `~/.dotfiles_backup/<timestamp>/` before overwriting
4. Copies configs to the correct locations — no symlinks

## Tools Included

### Shell & Terminal
| Tool | Description |
|------|-------------|
| zsh | Shell — with Oh My Zsh, zsh-autosuggestions, zsh-syntax-highlighting, p10k |
| tmux | Terminal multiplexer |
| kitty | GPU-accelerated terminal emulator |

### CLI Tools
| Tool | Description |
|------|-------------|
| bat | `cat` with syntax highlighting |
| btop | System resource monitor |
| atuin | Shell history with search |
| ripgrep | Fast content search |
| zoxide | Smarter `cd` |
| eza | Modern `ls` |
| tree | Directory tree viewer |
| duf | Disk usage viewer |
| yazi | Terminal file manager |
| zip / unzip / unrar / p7zip | Archive tools |

### Music
| Tool | Description |
|------|-------------|
| mpd | Music Player Daemon |
| mpc | CLI client for MPD |
| rmpc | TUI client for MPD |

### Media
| Tool | Description |
|------|-------------|
| neovim | Text editor |
| yt-dlp | Video/audio downloader |
| yt-x | Browse and watch YouTube in the terminal |
| mpv | Media player (dependency of yt-x) |
| fzf | Fuzzy finder (dependency of yt-x) |

### Applications
| Tool | Description |
|------|-------------|
| Firefox | Web browser |
| Telegram | Messaging |
| Slack | Team messaging |
| Signal | Encrypted messaging |
| FileZilla | FTP client |
| TigerVNC | VNC viewer |
| VLC | Media player |
| LibreOffice | Office suite |

### Custom Scripts
| Script | Location | Description |
|--------|----------|-------------|
| `dl.sh` | `~/Music/dl.sh` | Download audio from URL via yt-dlp, auto-adds to MPD |

## Configs Included

```
configs/
├── zsh/         → ~/.zshrc, ~/.p10k.zsh
├── tmux/        → ~/.tmux.conf
├── kitty/       → ~/.config/kitty/
├── yazi/        → ~/.config/yazi/
├── bat/         → ~/.config/bat/
├── btop/        → ~/.config/btop/
├── atuin/       → ~/.config/atuin/config.toml
├── rmpc/        → ~/.config/rmpc/
├── yt-x/        → ~/.config/yt-x/
├── mpd/         → ~/.config/mpd/mpd.conf
└── scripts/     → ~/Music/dl.sh
```

> `ripgrep` and `yt-dlp` config directories are reserved for future use.

## Adding a New Tool

1. Create `configs/<toolname>/` and drop the config files in
2. Add an `install_<toolname>()` function in `install.sh`
3. Call it in `main()`
