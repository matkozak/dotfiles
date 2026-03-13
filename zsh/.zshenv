# ~/.zshenv

# folder bootstrap
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"
export LESS="-R -F -X"
export MANPAGER="nvim +Man!"

# Python
export PIP_REQUIRE_VIRTUALENV=1

# Fzf
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="fd --type f --hidden --exclude .git"

# Claude
export ENABLE_LSP_TOOL=1
