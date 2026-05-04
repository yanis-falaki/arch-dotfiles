#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Swaync Installer"
ensure_prereqs

install_packages swaync gvfs libnotify python-pywal16
copy_config_dir "swaync" "swaync"
apply_default_pywal

success "Swaync component installed."
