set shell := ["sh", "-euc"]

packages := "zsh nvim git editorconfig tmux claude"

xdg_cache_home := env("XDG_CACHE_HOME", env("HOME") /".cache")
xdg_data_home  := env("XDG_DATA_HOME", env("HOME") /".local/share")
xdg_state_home := env("XDG_STATE_HOME", env("HOME") /".local/state")
zcomp_dir      := xdg_data_home / "zsh/completions"

# list available recipes
default:
    @just --list

# create required directories
[private]
@dirs:
    mkdir -p "{{ xdg_cache_home }}/zsh"
    mkdir -p "{{ xdg_state_home }}/zsh"
    mkdir -p "{{ zcomp_dir }}"

# symlink dotfile packages
stow: dirs
    stow -v --no-folding {{ packages }}

# re-stow (repair symlinks)
restow: dirs
    stow -v --no-folding -R {{ packages }}

# remove symlinks
unstow:
    stow -v -D {{ packages }}

# generate shell completions
completions: dirs
    #!/bin/sh
    set -eu
    gen() {
        # name tool command
        # command can be multiple words
        name="$1"; shift
        tool="$1"; shift
        if command -v "$tool" >/dev/null 2>&1; then
            "$@" > "{{ zcomp_dir }}/_$name"
            echo "  generated _$name"
        else
            echo "  skipping _$name ($tool not found)"
        fi
    }
    echo "Generating zsh completions..."
    gen cargo   rustup  rustup completions zsh cargo
    gen gh      gh      gh completion -s zsh
    gen mise    mise    mise completion zsh
    gen rustup  rustup  rustup completions zsh
    gen uv      uv      uv generate-shell-completion zsh
    gen uvx     uvx     uvx --generate-shell-completion zsh
    echo "Done."

# install Claude Code plugins (enable/disable is in settings.json)
claude-plugins:
    #!/bin/sh
    set -eu
    install() {
        if claude plugin list 2>/dev/null | grep -q "$1"; then
            echo "  already installed: $1"
        else
            claude plugin install "$1"
            echo "  installed: $1"
        fi
    }
    echo "Installing Claude Code plugins..."
    install pyright-lsp@claude-plugins-official
    install rust-analyzer-lsp@claude-plugins-official
    install typescript-lsp@claude-plugins-official
    install cloudflare@cloudflare
    echo "Done."

# full bootstrap: stow + completions
bootstrap: stow completions
