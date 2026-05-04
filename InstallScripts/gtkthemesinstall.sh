#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "GTK Themes Installer"
ensure_prereqs

install_packages nwg-look qogir-icon-theme materia-gtk-theme illogical-impulse-bibata-modern-classic-bin

info "Use nwg-look to apply GTK and icon themes."
success "GTK theme dependencies installed."
