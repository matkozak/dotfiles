#!/bin/sh
set -eu

# Install just if missing
if ! command -v just >/dev/null 2>&1; then
    echo "please install just first (e.g. apt install just)"
    exit 1
fi

# Hand off to justfile
just bootstrap
