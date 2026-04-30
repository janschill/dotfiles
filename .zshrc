autoload -U colors && colors
autoload -Uz compinit && compinit

source <(fzf --zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/env.zsh
source ~/.config/zsh/history.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/python.zsh
source ~/.config/zsh/macos.zsh
[[ -f ~/.config/zsh/work.zsh ]] && source ~/.config/zsh/work.zsh

file=~/secret/bash.sh
[ -f $file ] && source $file

file=~/.zshrc.local
[ -f $file ] && source $file

eval "$(mise activate zsh)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

if command -v zoxide &> /dev/null; then
  [[ -o interactive ]] && eval "$(zoxide init zsh --cmd cd)"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude-mem='$HOME/.bun/bin/bun "$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
