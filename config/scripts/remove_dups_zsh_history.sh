#! /bin/zsh

cd $HOME
if [[ -f ".zsh_history" ]]; then
    cp .zsh_history .zsh_history_bak
    sort -u .zsh_history_bak > .zsh_history
    echo "ZSH history is spotless now ✨"
else 
    echo "ZSH history file not found ❌"
fi
