#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

package_manager="$(detect_package_manager)"

case "$package_manager" in
    brew)
        install_brew_cask wezterm wezterm "$package_manager"
        ;;
    *)
        install_package wezterm wezterm "$package_manager"
        ;;
esac
