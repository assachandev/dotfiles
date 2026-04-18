# ✦ dotfiles

> Personal Ubuntu Server configuration files and automated setup script.
&nbsp;

## ⚡ Quick Start

```bash
git clone -b ubuntu https://github.com/assachandev/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

> **Ubuntu only.** The script will exit if `apt` is not detected.

&nbsp;

## ✦ How It Works

- Checks you're on Ubuntu (apt-based)
- Asks before installing each tool — skip anything you don't need
- Backs up existing configs to `~/.dotfiles_backup/<timestamp>/` before overwriting
- Copies config files directly — no symlinks
- Tools not available in apt (eza, duf, atuin, yazi) are installed from GitHub releases or official install scripts

&nbsp;

## 🧰 Tools

### Shell & Terminal
| Tool | Description | Source |
|------|-------------|--------|
| [zsh](https://www.zsh.org/) | Shell with Oh My Zsh, autosuggestions, syntax highlighting | apt |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Zsh theme | git clone |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer | apt |

### CLI Utilities
| Tool | Description | Source |
|------|-------------|--------|
| [bat](https://github.com/sharkdp/bat) | `cat` clone with syntax highlighting | apt (`batcat`) |
| [eza](https://github.com/eza-community/eza) | Modern replacement for `ls` | apt / GitHub releases |
| [fd](https://github.com/sharkdp/fd) | Fast and user-friendly `find` alternative | apt (`fd-find`) |
| [fzf](https://github.com/junegunn/fzf) | Command-line fuzzy finder | apt |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that learns your habits | install script |
| [atuin](https://github.com/atuinsh/atuin) | Shell history search and sync | install script |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Blazing fast search tool | apt |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager with plugin support | GitHub releases |
| [btop](https://github.com/aristocratos/btop) | System resource monitor | apt |
| [duf](https://github.com/muesli/duf) | Disk usage viewer | apt / GitHub releases |
| [tree](https://oldmanprogrammer.net/source.php?dir=projects/tree) | Directory tree display | apt |
| zip / unzip / p7zip | Archive tools | apt |

&nbsp;

> **Note:** `bat` is installed as `batcat` and `fd` as `fdfind` on some Ubuntu versions.
> The script automatically creates symlinks (`~/.local/bin/bat` and `~/.local/bin/fd`).
> Ensure `~/.local/bin` is in your `PATH`.

&nbsp;

## 📁 Config Structure

```
configs/
├── zsh/            →  ~/.zshrc  •  ~/.p10k.zsh
├── tmux/           →  ~/.tmux.conf
├── yazi/           →  ~/.config/yazi/
├── bat/            →  ~/.config/bat/
├── btop/           →  ~/.config/btop/
├── atuin/          →  ~/.config/atuin/config.toml
└── ripgrep/        →  ~/.config/ripgrep/config
```
