#!/usr/bin/env bash

set -euo pipefail

if command -v brew >/dev/null 2>&1; then
    echo "brew"
elif command -v apt-get >/dev/null 2>&1; then
    echo "apt"
elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
else
    echo "unsupported"
fi
