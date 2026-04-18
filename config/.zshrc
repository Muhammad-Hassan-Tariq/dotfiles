# ============================================================
# Hassan's Hybrid .zshrc for Arch + Powerlevel10k + Hyprland
# ============================================================

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
# History Configuration
# -----------------------------

HISTFILE=~/.zsh_history          # location of the history file
HISTFILESIZE=100000              # history limit of the file on disk
HISTSIZE=500000                  # current session's history limit
SAVEHIST=500000                  # zsh saves this many lines from the in-memory history list to the history file upon shell exit
unsetopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don\'t record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don\'t record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don\'t write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.

# -----------------------------
# Completion Settings
# -----------------------------
# Faster completion loading ⚡
autoload -Uz compinit
# Ignore insecure directories (important if you’re using Arch + Hyprland + powerlevel10k)
zstyle ':completion:*' rehash true
compinit -u

# Compile the completion dump to binary for even more speed
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
  zcompile "$zcompdump"
fi

# Menu-style completion and matching
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' verbose true

# -----------------------------
# Aliases and LS Colors
# -----------------------------
# EZA Command
alias ls='eza --icons --color=always --group-directories-first'
alias la='eza -A --icons --color=always --group-directories-first'
alias ll='eza -l --icons --color=always --group-directories-first'
alias lla='eza -la --icons --color=always --group-directories-first'
alias lg='eza -la --icons --color=always --group-directories-first --git'
alias tree='eza --tree --icons --color=always --group-directories-first'

alias treecpy='/bin/tree | wl-copy'
alias lscpy='/bin/ls -l --group-directories-first | wl-copy'
alias lscpyall='/bin/ls -la --group-directories-first | wl-copy'

# CD Command
alias ..='cd ..'
alias ...='cd ../..'

# Fuzzy Finder with Preview
alias ff='fd --type f | fzf --preview "bat --color=always --style=header,grid {}"'

# Search History with Fuzzy Finder
alias ffhist='cd $HOME && cat .zsh_history | fzf | wl-copy'

# Start Trilium Notes Server Instance
alias runtr='cd $HOME/tools/triliumNotes/triliumNotes && ./trilium.sh'

# Updat & push dotfiles to Github
alias dotsync='cd $HOME/dotfiles && git add . && git commit -m "Updated" && git push && cd -'

# Downloading shortcut using aria2c
alias dwld="aria2c -x 16 -s 16 --continue=true --retry-wait=2 --max-tries=0"

# Shortcuts to EDIT Configs
alias e_hyprland='nvim $HOME/.config/hypr/hyprland.conf'
alias e_zshrc='nvim $HOME/.zshrc'

# CPP Workspace
alias CPP_WORKSPACE='nvim "$HOME/programming/__eagle__ cortex/main.cpp"'

# Compile & Execute main.cpp File
cpprun() {
    # Default settings
    local file="main.cpp"
    local debug=0

    # Parse arguments
    for arg in "$@"; do
        if [[ "$arg" == "--debug" ]]; then
            debug=1
        else
            file="$arg"
        fi
    done

    local out="${file%.*}.out"

    # Colors
    GREEN='\033[0;32m'
    CYAN='\033[0;36m'
    RED='\033[0;31m'
    NC='\033[0m'

    if [[ $debug -eq 1 ]]; then
        # Debug compile
        if g++ -std=c++20 -Wall -Wextra -O0 -g "$file" -o "$out"; then
            echo -e "${GREEN}✅ Compilation successful (debug). Debugging $out...${NC}"
            gdb "$out"
        else
            echo -e "${RED}❌ Compilation failed.${NC}"
        fi
    else
        # Release compile
        if g++ -std=c++20 -Wall -Wextra -O2 "$file" -o "$out"; then
            echo -e "${GREEN}✅ Compilation successful. Running $out...${NC}"
            ./"$out"
        else
            echo -e "${RED}❌ Compilation failed.${NC}"
        fi
    fi
}

# The "Cheat Sheet" via `curl`
cheat() { curl -s cheat.sh/"$*" }

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
bindkey '^[[1;5C' kill-word         # Ctrl+Delete
bindkey '^[[3~' delete-char         # Delete key
bindkey '^L' forward-word           # Ctrl+L
bindkey '^H' backward-word          # Ctrl+H
bindkey '^[[H' beginning-of-line    # Home
bindkey '^[[F' end-of-line          # End
bindkey '^_ ' undo                  # Ctrl+_ to undo
bindkey '\eOP' forward-char         # Ctrl+E Autocomplete & Execute
bindkey '\eOQ' autosuggest-execute  # Ctrl+E Autocomplete & Execute
bindkey '^I' expand-or-complete     # Tab Completion

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
# Other Environment Variables
# -----------------------------
export JAVA_TOOL_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"

# -----------------------------
# Powerlevel10k Configuration
# -----------------------------
# Load user-specific Powerlevel10k settings if available
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Colorize 'less' and 'man' pages (Pure eye-candy)
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

