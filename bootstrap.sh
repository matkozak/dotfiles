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
    # mise isn't in the Ubuntu archive; add its PPA once
    if ! command -v mise >/dev/null 2>&1; then
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:jdxcode/mise
    fi

    sed 's/#.*//' apt.txt | xargs sudo apt-get install -y

    # powerlevel10k (no apt package)
    p10k="$HOME/.local/share/powerlevel10k"
    [ -d "$p10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k"

    # just comes from mise; the mise config isn't stowed yet, so pin it here
    mise exec just@latest -- just bootstrap
fi
