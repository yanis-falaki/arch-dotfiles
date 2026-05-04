#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Hyprlock Installer"
ensure_prereqs

install_packages hyprlock python-pywal16
copy_config_dir "wal" "wal"
copy_config_file "hypr/hyprlock.conf" "hypr/hyprlock.conf"
copy_config_file "hypr/hypridle.conf" "hypr/hypridle.conf"
apply_default_pywal

success "Hyprlock component installed."
