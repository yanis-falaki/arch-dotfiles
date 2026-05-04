#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Waybar Installer"
ensure_prereqs

install_packages waybar hyprpicker python-pywal16
copy_config_dir "waybar" "waybar"
apply_default_pywal

read -rp "Install Bluetooth integration (blueman + bluez)? (Y/n): " bt
if [[ "${bt:-y}" =~ ^[Yy]$ ]]; then
	install_packages blueman bluez
	if command -v systemctl >/dev/null 2>&1; then
		sudo systemctl enable --now bluetooth || warn "Could not enable bluetooth service automatically."
	fi
fi

success "Waybar component installed."
