export EDITOR="nvim"

# Restore emacs-style line navigation in vi mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/secret/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/code/janschill/samla/bin:$PATH"
export NOTES_ROOT="$HOME/code/notes"

export CLICOLOR=1

export PS1="%n:%~%# "

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

proton_drive_dirs=("$HOME"/Library/CloudStorage/ProtonDrive-*-folder(N))
if (( ${#proton_drive_dirs[@]} > 0 )); then
    export PROTON_DRIVE="${proton_drive_dirs[1]}"
fi
export ICLOUDE_DRIVE="$HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs"
export K9S_CONFIG_DIR=~/.config/k9s
export XDG_CONFIG_HOME="$HOME/.config"
