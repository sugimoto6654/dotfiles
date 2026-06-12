#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_INSTALL_APT_UPDATED_FILE
DOTFILES_INSTALL_APT_UPDATED_FILE="$(mktemp -t dotfiles-install-apt-updated.XXXXXX)"
rm -f "$DOTFILES_INSTALL_APT_UPDATED_FILE"
trap 'rm -f "$DOTFILES_INSTALL_APT_UPDATED_FILE"' EXIT

tools=(
    git
    zsh
    curl
    ghq
    fzf
    nvim
    starship
    wezterm
    uv
)

for tool in "${tools[@]}"; do
    bash "${SCRIPT_DIR}/install/${tool}.sh"
done
