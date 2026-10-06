# Dedupe: FPATH is exported by brew shellenv, so nested shells would otherwise
# accumulate duplicates and invalidate the compinit dump on every start.
typeset -U fpath path

autoload -U colors && colors
autoload -Uz compinit

# The following line has been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
# End of Docker CLI completions

fpath=("$HOME/.local/share/zsh/site-functions" $fpath)

# Full check at most once a day; otherwise trust the cached dump
stale_zcompdump=(~/.zcompdump(N.mh+24))
if (( $#stale_zcompdump )); then
  compinit
  touch ~/.zcompdump
else
  compinit -C
fi
unset stale_zcompdump

if command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
  source <(fzf --zsh)
fi

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

if command -v zoxide &> /dev/null; then
  [[ -o interactive ]] && eval "$(zoxide init zsh --cmd cd)"
fi

[[ "$TERM_PROGRAM" == "iTerm.app" ]] && test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude-mem='$HOME/.bun/bin/bun "$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

eval "$(mise activate zsh)"
