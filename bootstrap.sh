#!/bin/sh
set -eu
if ! command -v just >/dev/null 2>&1; then
    echo "please install just first (e.g. apt install just)"
    exit 1
fi
just bootstrap
