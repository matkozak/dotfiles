# ~/.config/zsh/.zprofile

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $path
)

eval "$(mise activate zsh)"
