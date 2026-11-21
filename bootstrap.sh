#!/bin/sh
set -eu
cd "$(dirname "$0")"

if [ "$(uname)" = Darwin ]; then
    # Install Homebrew if missing
    if [ ! -x /opt/homebrew/bin/brew ]; then
        echo "installing homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Install just if missing
    if ! command -v just >/dev/null 2>&1; then
        echo "installing just..."
        brew install just
    fi

    # Hand off to justfile
    just bootstrap
else
    sudo apt-get update

    # mise isn't in the Debian/Ubuntu archives; enable its apt repo once
    if ! command -v mise >/dev/null 2>&1; then
        sudo apt-get install -y extrepo
        sudo extrepo enable mise
        sudo apt-get update
    fi

    sed 's/#.*//' linux/apt.txt | xargs sudo apt-get install -y

    # Make zsh the login shell
    zsh="$(command -v zsh)"
    user="$(id -un)"
    [ "$(getent passwd "$user" | cut -d: -f7)" = "$zsh" ] || sudo chsh -s "$zsh" "$user"

    # powerlevel10k (no apt package)
    p10k="$HOME/.local/share/powerlevel10k"
    [ -d "$p10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k"

    # Hand off to justfile
    just bootstrap
fi
