# ============================================================
# Hassan's Hybrid .zshrc for Arch + Powerlevel10k + Hyprland
# ============================================================

# -----------------------------
# History Configuration
# -----------------------------
HISTFILE=~/.zsh_history       # File where command history is stored
HISTSIZE=10000                # Max commands kept in memory
SAVEHIST=10000                # Max commands saved to disk

# History behavior
setopt INC_APPEND_HISTORY     # Immediately append commands to history file
setopt SHARE_HISTORY          # Share history across multiple terminals
setopt HIST_IGNORE_DUPS       # Ignore duplicate commands in history
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt hist_expire_dups_first # Remove older duplicates when history is full
setopt hist_verify            # Show command after expansion before executing

# -----------------------------
# Completion Settings
# -----------------------------
# Faster completion loading ⚡
autoload -Uz compinit
for dump in ~/.zcompdump(N.m1); do
  compinit
done
compinit -C

# Menu-style completion and matching
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' verbose true

# -----------------------------
# Aliases and LS Colors
# -----------------------------
# EXA Command
alias ls='exa --icons --color=always --group-directories-first'
alias ll='exa -l --icons --color=always --group-directories-first'
alias lla='exa -la --icons --color=always --group-directories-first'
alias la='exa -A --icons --color=always --group-directories-first'
alias lg='exa -la --icons --color=always --group-directories-first --git'
alias tree='exa --tree --icons --color=always --group-directories-first'

alias treecpy='exa --tree --icons --color=always --group-directories-first | wl-copy'
alias lscpy='exa --icons --color=always --group-directories-first | wl-copy'

# Fuzzy Finder with Preview
alias ff='fd --type f | fzf --preview "bat --color=always --style=header,grid {}"'

# Start Trilium Notes Server Instance
alias runtr='(cd $HOME/Tools/TriliumNotes/TriliumNotes && ./trilium.sh)'

# Updat & push dotfiles to Github
alias dotsync='cd $HOME/dotfiles && git add . && git commit -m "Update rice" && git push && cd -'

# Downloading shortcut using aria2c
alias dwld="aria2c -x 16 -s 16 --continue=true --retry-wait=2 --max-tries=0"

# Run Budget script
alias budget='(cd $HOME/Tools/Personal-DBs/Budget && ./script.sh)'

# Compile & Execute main.cpp File
alias exec_cpp='g++ ./main.cpp -o output && ./output'

# The "Cheat Sheet" via `curl`
cheat() { curl -s cheat.sh/"$*" }

# -----------------------------
# Powerlevel10k Instant Prompt
# -----------------------------
# Instant prompt for faster startup; requires console input above this block
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------
# Powerlevel10k Theme
# -----------------------------
# Core theme file
source ~/powerlevel10k/powerlevel10k.zsh-theme

# -----------------------------
# Zsh Plugins
# -----------------------------
# Syntax highlighting for commands
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions based on command history
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'  # Light gray suggestions
fi

# -----------------------------
# Keybindings (Emacs-style)
# -----------------------------
# Navigation and editing shortcuts
bindkey -e                          # Use emacs keybindings
bindkey '^U' backward-kill-line     # Ctrl+U to delete entire line
bindkey '^[[3;5~' kill-word         # Ctrl+Delete to delete word
bindkey '^[[3~' delete-char         # Delete key
bindkey '^[[1;5C' forward-word      # Ctrl+Right to move word forward
bindkey '^[[1;5D' backward-word     # Ctrl+Left to move word backward
bindkey '^[[5~' beginning-of-buffer-or-history  # Page Up for start of history
bindkey '^[[6~' end-of-buffer-or-history        # Page Down for end of history
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
bindkey '^[[Z' undo                # Shift+Tab to undo

# -----------------------------
# Environment Variables
# -----------------------------
# -----------------------------
# Browser & GUI Optimizations
# -----------------------------
export MOZ_ENABLE_WAYLAND=1                      # The most important flag for Zen!
export MOZ_DBUS_REMOTE=1                         # Improves IPC communication
export MOZ_DISABLE_RDD_SANDBOX=1                 # Helps NVIDIA hardware decoding
export EGL_PLATFORM=wayland                      # Forces the correct rendering backend

# -----------------------------
# Powerlevel10k Configuration
# -----------------------------
# Load user-specific Powerlevel10k settings if available
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# 🎨 Colorize 'less' and 'man' pages (Pure eye-candy)
export LESS_TERMCAP_mb=$'\E[1;31m'   # blink -> red
export LESS_TERMCAP_md=$'\E[1;36m'   # bold -> cyan
export LESS_TERMCAP_me=$'\E[0m'      # reset
export LESS_TERMCAP_so=$'\E[01;33m'  # standout -> yellow
export LESS_TERMCAP_se=$'\E[0m'      # reset
export LESS_TERMCAP_us=$'\E[1;32m'   # underline -> green
export LESS_TERMCAP_ue=$'\E[0m'      # reset

# Smart Sorting and Comments
setopt numericglobsort
setopt interactivecomments
setopt nonomatch

# ============================================================
# End of .zshrc
# ============================================================

