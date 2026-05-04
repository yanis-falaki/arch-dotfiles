#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Keyd"

sudo cp ~/arch-dotfiles/.config/keyd/ /etc/keyd -r

install_packages keyd
systemctl enable keyd
systemctl start keyd

success "Keyd component installed."
