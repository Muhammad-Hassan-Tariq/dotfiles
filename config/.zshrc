# ============================================================
# The Eagle's Hybrid .zshrc for Arch Linux
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
HISTFILESIZE=50000               # history limit of the file on disk
HISTSIZE=50000                   # current session's history limit
SAVEHIST=50000                   # zsh saves this many lines from the in-memory history list to the history file upon shell exit
unsetopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don\'t record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don\'t record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don\'t write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.

setopt autocd                                      # type directory name to cd into it
WORDCHARS=${WORDCHARS//\/}                         # slashes don't break word jumping
PROMPT_EOL_MARK=""                                 # hide '%' when output lacks newline
alias history="history 0"                          # show full history with 'history'
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'  # better time command output

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

# -----------------------------
# Enhanced Completion 
# -----------------------------
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# -----------------------------
# Keybindings (Kali-inspired)
# -----------------------------
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U delete entire line
bindkey '^[[3;5~' kill-word                       # ctrl + Delete
bindkey '^[[3~' delete-char                       # Delete key
bindkey '^[[1;5C' forward-word                    # ctrl + Right Arrow
bindkey '^[[1;5D' backward-word                   # ctrl + Left Arrow
bindkey '^[[5~' beginning-of-buffer-or-history    # Page Up
bindkey '^[[6~' end-of-buffer-or-history          # Page Down
bindkey '^[[H' beginning-of-line                  # Home key
bindkey '^[[F' end-of-line                        # End key
bindkey '^[[Z' undo                               # Shift + Tab (undo last action)

# -----------------------------
# Aliases
# -----------------------------
# EZA Command
alias ls='eza --icons --color=always --group-directories-first'             # show files
alias la='eza -A --icons --color=always --group-directories-first'          # show hidden files
alias ll='eza -l --icons --color=always --group-directories-first'          # list files
alias lla='eza -la --icons --color=always --group-directories-first'        # list hidden files
alias lg='eza -la --icons --color=always --group-directories-first --git'   # show git files
alias ld='eza -ld .*'                                                       # show dotfiles only

alias lt='eza --tree --icons --color=always --group-directories-first'                 # show tree
alias lt2='eza --tree --icons --level=2 --color=always --group-directories-first'      # show tree 2 levels deep


alias ltc='eza --tree --icons --color=always --group-directories-first | wl-copy'
alias lc='/bin/ls -l --group-directories-first | wl-copy'
alias lca='/bin/ls -la --group-directories-first | wl-copy'

# CD Command
alias ..='cd ..'
alias ...='cd ../..'

# File Preview With FZF
alias fp="fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'" 

alias runtr='cd $HOME/tools/triliumNotes/triliumNotes && ./trilium.sh'                                                   # Start Trilium Notes Server Instance
alias dotsync='git -C $HOME/dotfiles add . && git -C $HOME/dotfiles commit -m "Updated" && git -C $HOME/dotfiles push'   # Update & push dotfiles to Github
alias dwld="aria2c -x 16 -s 16 --continue=true --retry-wait=2 --max-tries=0"                                             # Downloading shortcut using aria2c

# Shortcuts to EDIT Configs
alias e_h='nvim $HOME/.config/hypr/hyprland.conf'
alias e_z='nvim $HOME/.zshrc'


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

# Compile & Upload Arduino Code with Auto-Port Detection
arduino-flash() {
    local board_type=$1
    local fqbn=""
    
    case $board_type in
        nano) fqbn="arduino:avr:nano:cpu=atmega328" ;;
        uno)  fqbn="arduino:avr:uno" ;;
        *) echo "❌ Use: arduino-flash nano or uno"; return 1 ;;
    esac

    # Use 'command ls' to bypass color aliases and get raw text
    local port=$(command ls /dev/ttyUSB* 2>/dev/null | head -n 1)
    
    if [ -z "$port" ]; then
        echo "💀 No device found on /dev/ttyUSB*"
        return 1
    fi

    echo "✅ Found: $port | FQBN: $fqbn"
    
    # stty should work now that $port is clean text
    stty -F "$port" hupcl 
    
    arduino-cli compile --upload -v -p "$port" --fqbn "$fqbn" .
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

# FZF key bindings and completion
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

# Smart directory jumping
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# -----------------------------
# Evaluations & Executions
# -----------------------------
eval $(thefuck --alias) # The Fuck

# -----------------------------
# Environment Variables
# -----------------------------
export EDITOR=nvim

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

# Smart Sorting and Comments
setopt numericglobsort
setopt interactivecomments
setopt nonomatch

# ============================================================
# End of .zshrc
# ============================================================
