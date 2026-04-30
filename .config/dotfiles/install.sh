#!/usr/bin/env bash
set -euo pipefail

PUBLIC_REPO="git@github.com:janschill/dotfiles.git"
WORK_REPO="git@github.com:janschill/dotfiles-work.git"
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_WORK_DIR="$HOME/.dotfiles-work"
PUBLIC_EXCLUDES="$HOME/.config/dotfiles/public.gitignore"
WORK_EXCLUDES="$HOME/.config/dotfiles/work.gitignore"

git_home() {
  /usr/bin/git --git-dir="$1" --work-tree="$HOME" "${@:2}"
}

append_once() {
  local line="$1"
  local file="$2"

  touch "$file"
  if ! grep -qxF "$line" "$file"; then
    printf '\n%s\n' "$line" >> "$file"
  fi
}

checkout_with_backup() {
  local git_dir="$1"
  local output status backup_dir

  set +e
  output="$(git_home "$git_dir" checkout 2>&1)"
  status=$?
  set -e

  if [[ "$status" -eq 0 ]]; then
    return 0
  fi

  if ! grep -q "would be overwritten by checkout" <<< "$output"; then
    printf '%s\n' "$output" >&2
    return "$status"
  fi

  backup_dir="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup_dir"

  printf '%s\n' "$output" |
    awk '/^[[:space:]]+[^[:space:]]/ { print $1 }' |
    while IFS= read -r path; do
      [[ -z "$path" ]] && continue
      mkdir -p "$backup_dir/$(dirname "$path")"
      mv "$HOME/$path" "$backup_dir/$path"
    done

  git_home "$git_dir" checkout
}

setup_bare_repo() {
  local repo_url="$1"
  local git_dir="$2"
  local excludes_file="$3"

  if [[ ! -d "$git_dir" ]]; then
    git clone --bare "$repo_url" "$git_dir"
  fi

  git_home "$git_dir" config --local status.showUntrackedFiles no
  git_home "$git_dir" config --local core.excludesFile "$excludes_file"
  checkout_with_backup "$git_dir"
}

ensure_xcode_cli_tools() {
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Xcode Command Line Tools install started. Re-run this script after it finishes."
    exit 1
  fi
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ "$(uname -m)" == "arm64" ]]; then
    append_once 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

install_neovim_plugins() {
  if ! command -v nvim >/dev/null 2>&1; then
    return 0
  fi

  if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  fi

  nvim --headless +PlugInstall +qall
}

main() {
  echo "Setting up dotfiles"

  ensure_xcode_cli_tools

  setup_bare_repo "$PUBLIC_REPO" "$DOTFILES_DIR" "$PUBLIC_EXCLUDES"

  read -r -p "Is this a work machine? [y/N] " is_work_machine
  case "$is_work_machine" in
    y|Y|yes|YES)
      setup_bare_repo "$WORK_REPO" "$DOTFILES_WORK_DIR" "$WORK_EXCLUDES"
      ;;
  esac

  ensure_homebrew
  brew bundle --file="$HOME/.config/homebrew/Brewfile"
  if [[ -f "$HOME/.config/homebrew/Brewfile.work" ]]; then
    brew bundle --file="$HOME/.config/homebrew/Brewfile.work"
  fi

  if [[ -f "$HOME/.macos" ]]; then
    bash "$HOME/.macos"
  fi

  install_neovim_plugins

  echo "Dotfiles setup complete. Restart your shell or run: source ~/.zshrc"
}

main "$@"
