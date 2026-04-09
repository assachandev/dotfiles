# ✦ dotfiles

> Personal Arch Linux configuration files and automated setup script.

&nbsp;

## ⚡ Quick Start

```bash
git clone https://github.com/assachandev/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

> **Arch Linux only.** The script will exit if `pacman` is not detected.

&nbsp;

## ✦ How It Works

- Checks you're on Arch Linux
- Installs **yay** and **paru** (AUR helpers) automatically
- Asks before installing each tool — skip anything you don't need
- Backs up existing configs to `~/.dotfiles_backup/<timestamp>/` before overwriting
- Copies config files directly — no symlinks

&nbsp;

## 🧰 Tools

### Shell & Terminal
| Tool | Description |
|------|-------------|
| [zsh](https://www.zsh.org/) | Shell with Oh My Zsh, autosuggestions, syntax highlighting, Powerlevel10k |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal emulator |

### CLI Utilities
| Tool | Description |
|------|-------------|
| [bat](https://github.com/sharkdp/bat) | `cat` clone with syntax highlighting |
| [eza](https://github.com/eza-community/eza) | Modern replacement for `ls` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that learns your habits |
| [atuin](https://github.com/atuinsh/atuin) | Shell history search and sync |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Blazing fast search tool |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager |
| [btop](https://github.com/aristocratos/btop) | System resource monitor |
| [duf](https://github.com/muesli/duf) | Disk usage viewer |
| [tree](https://oldmanprogrammer.net/source.php?dir=projects/tree) | Directory tree display |
| zip / unzip / unrar / p7zip | Archive tools |

### Editor
| Tool | Description |
|------|-------------|
| [neovim](https://neovim.io/) | Hyperextensible text editor |

### Music
| Tool | Description |
|------|-------------|
| [mpd](https://www.musicpd.org/) | Music Player Daemon |
| [mpc](https://www.musicpd.org/clients/mpc/) | Minimal CLI client for MPD |
| [rmpc](https://github.com/mierak/rmpc) | Feature-rich TUI client for MPD |

### Media
| Tool | Description |
|------|-------------|
| [yt-dlp](https://github.com/yt-dlp/yt-dlp) | Download video and audio from the web |
| [yt-x](https://github.com/Benexl/yt-x) | Browse and watch YouTube in the terminal |
| [mpv](https://mpv.io/) | Lightweight media player |
| [fzf](https://github.com/junegunn/fzf) | Command-line fuzzy finder |

### Applications
| Tool | Description |
|------|-------------|
| [Firefox](https://www.mozilla.org/firefox/) | Web browser |
| [Telegram](https://telegram.org/) | Messaging |
| [Slack](https://slack.com/) | Team communication |
| [Signal](https://signal.org/) | Encrypted messaging |
| [FileZilla](https://filezilla-project.org/) | FTP client |
| [TigerVNC](https://tigervnc.org/) | VNC viewer |
| [VLC](https://www.videolan.org/vlc/) | Media player |
| [LibreOffice](https://www.libreoffice.org/) | Office suite |

&nbsp;

## 📁 Config Structure

```
configs/
├── zsh/            →  ~/.zshrc  •  ~/.p10k.zsh
├── tmux/           →  ~/.tmux.conf
├── kitty/          →  ~/.config/kitty/
├── yazi/           →  ~/.config/yazi/
├── bat/            →  ~/.config/bat/
├── btop/           →  ~/.config/btop/
├── atuin/          →  ~/.config/atuin/config.toml
├── rmpc/           →  ~/.config/rmpc/
├── yt-x/           →  ~/.config/yt-x/
├── mpd/            →  ~/.config/mpd/mpd.conf
└── scripts/
    └── dl.sh       →  ~/Music/dl.sh
```

&nbsp;

## 🎵 Custom Script — `dl.sh`

Downloads audio from any URL via `yt-dlp`, converts to MP3, and auto-adds to MPD library.

```bash
~/Music/dl.sh
# Artist/Folder (default: .): Pink Floyd
# URL: <youtube or any supported url>
```
