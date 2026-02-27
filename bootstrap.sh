#!/bin/sh
set -eu

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
