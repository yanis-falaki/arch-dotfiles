#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Wofi Installer"
ensure_prereqs

install_packages wofi python-pywal16
copy_config_dir "wofi" "wofi"
apply_default_pywal

success "Wofi component installed."
