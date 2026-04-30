git_branch() {
  local branch=$(git branch 2>/dev/null | grep "\*" | sed -e 's/* \(.*\)/\1/')
  if [[ -n $branch ]]; then
    echo " %F{cyan}[${branch}]%f"
  fi
}

is_project_directory() {
  # Check for common project indicator files
  [[ -f "package.json" ]] || # Node.js projects
  [[ -f "tsconfig.json" ]] || # TypeScript projects
  [[ -f "serverless.yml" ]] || # Serverless/Lambda projects
  [[ -f "template.yaml" ]] || # AWS SAM projects
  [[ -d "node_modules" ]] || # Node.js projects with installed dependencies
  [[ -f "Gemfile" ]] || # Ruby projects
  [[ -f "requirements.txt" ]] || # Python projects
  [[ -f "go.mod" ]] || # Go projects
  [[ -f "Cargo.toml" ]] # Rust projects
}

mise_env_info() {
  if command -v mise &>/dev/null && { [[ -f "mise.toml" ]] || [[ -f ".tool-versions" ]] || is_project_directory; }; then
    local env_info=""
    local tools=("node" "python" "go" "ruby" "rust") # Add commonly used tools

    for tool in ${tools[@]}; do
      # Check if the tool is relevant for this project
      local is_relevant=false

      case $tool in
        node|nodejs)
          [[ -f "package.json" ]] || [[ -f "tsconfig.json" ]] || [[ -d "node_modules" ]] && is_relevant=true
          ;;
        python)
          [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -d "venv" ]] && is_relevant=true
          ;;
        go)
          [[ -f "go.mod" ]] || [[ -f "go.sum" ]] && is_relevant=true
          ;;
        ruby)
          [[ -f "Gemfile" ]] || [[ -f "Rakefile" ]] && is_relevant=true
          ;;
        rust)
          [[ -f "Cargo.toml" ]] && is_relevant=true
          ;;
        *)
          is_relevant=false
          ;;
      esac

      # If we have a mise.toml or .tool-versions, check if the tool is configured
      if [[ -f "mise.toml" ]] || [[ -f ".tool-versions" ]]; then
        if [[ -f "mise.toml" ]] && grep -q "^${tool}\s*=" mise.toml; then
          is_relevant=true
        fi
        if [[ -f ".tool-versions" ]] && grep -q "^${tool}\s" .tool-versions; then
          is_relevant=true
        fi
      fi

      # Only show version if tool is relevant for this project
      if $is_relevant; then
        local version=$(mise current ${tool} 2>/dev/null | cut -d' ' -f2)
        if [[ -n $version ]]; then
          local icon=""
          case $tool in
            node|nodejs)
              icon="⬢"
              color="green"
              ;;
            python)
              icon="🐍"
              color="blue"
              ;;
            go)
              icon="🔹"
              color="cyan"
              ;;
            ruby)
              icon="💎"
              color="red"
              ;;
            rust)
              icon="🦀"
              color="yellow"
              ;;
            *)
              icon="•"
              color="magenta"
              ;;
          esac

          env_info+=" %F{$color}$icon ${version}%f"
        fi
      fi
    done

    echo "$env_info"
  fi
}

venv_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%F{yellow}(${VIRTUAL_ENV:t})%f "
  fi
}

set_prompt() {
  local short_path="%2~"
  PROMPT="$(venv_info)%n:${short_path} %# "
  RPROMPT="$(mise_env_info)"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

precmd_functions+=(set_prompt)
