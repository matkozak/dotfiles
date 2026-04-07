set shell := ["sh", "-euc"]

packages := "zsh nvim ghostty git editorconfig tmux"

xdg_cache_home := env("XDG_CACHE_HOME", home_directory() / ".cache")
xdg_data_home  := env("XDG_DATA_HOME", home_directory() / ".local/share")
xdg_state_home := env("XDG_STATE_HOME", home_directory() / ".local/state")
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

# install Brewfile packages
brew:
    brew bundle --file=Brewfile

# symlink dotfile packages
stow: dirs
    stow -v {{ packages }}

# re-stow (repair symlinks)
restow: dirs
    stow -v -R {{ packages }}

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

# enable SSH access
ssh:
    sudo systemsetup -setremotelogin on
    @echo ""
    @echo "  === Manual: disable password auth ==="
    @echo "      sudo vi /etc/ssh/sshd_config"
    @echo "      Set: PasswordAuthentication no"
    @echo "      Then: sudo launchctl kickstart -k system/com.openssh.sshd"
    @echo ""
    @echo "  === Manual: add your public key ==="
    @echo "      mkdir -p ~/.ssh && cat your_key.pub >> ~/.ssh/authorized_keys"
    @echo "      chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

# apply macOS preferences
macos:
    sh macos/defaults.sh

# full bootstrap: brew + stow + completions
bootstrap: brew stow completions
