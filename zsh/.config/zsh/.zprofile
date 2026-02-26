# ~/.config/zsh/.zprofile

# keep PATH items unique
typeset -U path

# Homebrew (sets HOMEBREW_PREFIX, prepends to PATH)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Other PATH modifications
path=(
  $HOME/.local/bin    # uv, pipx, etc.
  $HOME/.cargo/bin    # rustup, cargo
  $path
)

# Tool activations
eval "$(mise activate zsh)"
