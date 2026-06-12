#!/usr/bin/env bash

set -euo pipefail

INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APT_UPDATED_FILE="${DOTFILES_INSTALL_APT_UPDATED_FILE:-}"

has_command() {
    command -v "$1" >/dev/null 2>&1
}

detect_package_manager() {
    bash "${INSTALL_DIR}/detect-package-manager.sh"
}

run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif has_command sudo; then
        sudo "$@"
    else
        echo "error: sudo is required to run: $*" >&2
        return 1
    fi
}

install_package() {
    local command_name="$1"
    local package_name="$2"
    local package_manager="${3:-$(detect_package_manager)}"

    if has_command "$command_name"; then
        echo "skip: $command_name is already installed"
        return 0
    fi

    case "$package_manager" in
        brew)
            brew install "$package_name"
            ;;
        apt)
            if [ -n "$APT_UPDATED_FILE" ]; then
                if [ ! -f "$APT_UPDATED_FILE" ]; then
                    run_as_root apt-get update
                    : >"$APT_UPDATED_FILE"
                fi
            else
                run_as_root apt-get update
            fi
            run_as_root apt-get install -y "$package_name"
            ;;
        dnf)
            run_as_root dnf install -y "$package_name"
            ;;
        pacman)
            run_as_root pacman -S --needed --noconfirm "$package_name"
            ;;
        *)
            echo "error: unsupported package manager" >&2
            return 1
            ;;
    esac
}

install_brew_cask() {
    local command_name="$1"
    local cask_name="$2"
    local package_manager="${3:-$(detect_package_manager)}"

    if has_command "$command_name"; then
        echo "skip: $command_name is already installed"
        return 0
    fi

    if [ "$package_manager" != "brew" ]; then
        echo "skip: $command_name requires Homebrew cask on this installer"
        return 0
    fi

    brew install --cask "$cask_name"
}
