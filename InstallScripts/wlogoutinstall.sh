#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Wlogout Installer"
ensure_prereqs

install_packages wlogout python-pywal16
copy_config_dir "wlogout" "wlogout"
apply_default_pywal

success "Wlogout component installed."
