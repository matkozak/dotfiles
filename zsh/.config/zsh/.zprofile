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

# Auto-attach remote clients to tmux session
if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]; then
    exec tmux new -A -s remote
fi
