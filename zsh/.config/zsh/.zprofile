# ~/.config/zsh/.zprofile

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $path
)

eval "$(mise activate zsh)"

# Auto-attach remote clients to tmux session
if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]; then
    exec tmux new -A -s remote
fi
