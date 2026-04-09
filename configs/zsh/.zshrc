# 1. Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. Environment Variables
export EDITOR='nvim'
export PATH=$HOME/.local/bin:$HOME/.atuin/bin:$PATH

# 3. Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(git sudo docker extract)
source $ZSH/oh-my-zsh.sh

# 4. Theme & Appearance (Powerlevel10k)
#source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme

# 5. Plugins
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 6. CLI Tools Integration (Init)
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh)"

# 7. Aliases
# --- Core ---
alias nv='nvim'
alias yz='yazi'
alias ..='cd ..'
alias grep='grep --color=auto'

# --- Modern ls (eza) ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias tree='eza --tree --icons'

# --- Modern CLI Tools ---
alias rg='rg --smart-case'
alias duf='duf'
if command -v fdfind > /dev/null; then
    alias fd='fdfind'
fi
if command -v batcat > /dev/null; then
    alias bat='batcat'
fi

# 8. Completion System
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
