#!/usr/bin/env bash

set -euo pipefail

link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest" = "src")" ]; then
            echo "skip: $dest already points to $src"
            return 0
        else
            echo "warn : $dest is already a symlink to $(readlink "$dest")"
            echo "       expected: $src"
        fi
    fi

    if [ -e "$dest" ]; then
        echo "warn: $dest already exists and is not a symlink"
        return 1
    fi

    ln -s "$src" "$dest"
    echo "linked: $dest -> $src"
}

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "dotfiles directory: ${DOTFILES}"

link_file "${DOTFILES}/config/nvim" "${HOME}/.config/nvim"
link_file "${DOTFILES}/config/wezterm" "${HOME}/.config/wezterm"
link_file "${DOTFILES}/config/starship.toml" "${HOME}/.config/starship.toml"
# link_file "${DOTFILES}/tmux.conf" "${HOME}/.tmux.conf"

