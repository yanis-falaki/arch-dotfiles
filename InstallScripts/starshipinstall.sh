#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Starship Installer"
ensure_prereqs

install_packages starship
copy_config_file "starship.toml" "starship.toml"

success "Starship component installed."
