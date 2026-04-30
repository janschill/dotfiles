# ---------------------------------------------------------------------------
# Python venv helpers
# ---------------------------------------------------------------------------
# Uses the Python version managed by mise (or system fallback).
# Convention: venvs live in .venv/ inside the project directory.
# ---------------------------------------------------------------------------

# Create a venv (optionally with a custom path) and activate it.
#   venv          -> creates .venv using current python3
#   venv myenv    -> creates myenv/
venv() {
  local dir="${1:-.venv}"
  python3 -m venv "$dir" && source "$dir/bin/activate"
}

# Activate an existing venv.
#   va            -> activates .venv
#   va myenv      -> activates myenv/
va() {
  local dir="${1:-.venv}"
  if [[ ! -f "$dir/bin/activate" ]]; then
    echo "No venv found at $dir — create one with: venv $dir" >&2
    return 1
  fi
  source "$dir/bin/activate"
}

# Deactivate the current venv.
alias vd='deactivate'

# Install packages into the active venv and freeze to requirements.txt.
#   vpi flask gunicorn
vpi() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "No active venv. Run: venv  or  va" >&2
    return 1
  fi
  pip install "$@" && pip freeze > requirements.txt
}

# Install from requirements.txt into the active venv.
#   vpr
#   vpr requirements-dev.txt
vpr() {
  if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "No active venv. Run: venv  or  va" >&2
    return 1
  fi
  pip install -r "${1:-requirements.txt}"
}

# ---------------------------------------------------------------------------
# Global Python tools via pipx
# ---------------------------------------------------------------------------
# pipx installs each tool in its own isolated venv so they never conflict.
# Install pipx once:  brew install pipx && pipx ensurepath

if command -v pipx &>/dev/null; then
  alias pxi='pipx install'
  alias pxu='pipx upgrade-all'
  alias pxl='pipx list'
  alias pxr='pipx uninstall'
fi
