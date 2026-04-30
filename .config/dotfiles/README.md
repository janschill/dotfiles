# Dotfiles

Public dotfiles and small shell tools for my macOS development setup.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/janschill/dotfiles/main/.config/dotfiles/install.sh | bash
```

The installer clones the public bare repository into `~/.dotfiles`, checks it
out with `$HOME` as the work tree, and configures:

```bash
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

On work machines, answer `yes` when prompted. That also clones the private
overlay into `~/.dotfiles-work` and configures:

```bash
alias dot-work='git --git-dir=$HOME/.dotfiles-work --work-tree=$HOME'
```

## Layout

- `bin/` contains shared scripts.
- `.config/dotfiles/` contains bootstrap scripts and the public bare-repo
  exclude file. The private overlay ships its own work exclude file.
- `.config/zsh/`, `.gitconfig`, `.zshrc`, `.macos`, and app config directories
  contain shared machine setup.

Work-specific config lives in the private `janschill/dotfiles-work` overlay.
The public files only include conditional hooks such as:

```bash
[[ -f ~/.config/zsh/work.zsh ]] && source ~/.config/zsh/work.zsh
```

and:

```ini
[includeIf "gitdir:~/code/vippsas/"]
	path = ~/.config/git/work.gitconfig
```

## Daily Use

```bash
dot status
dot add ~/.config/example/config
dot commit -m "Add example config"
dot push
```

For work-only paths:

```bash
dot-work status
dot-work add ~/.config/work-example/config
dot-work commit -m "Add work example config"
dot-work push
```
