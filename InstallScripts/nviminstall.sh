#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

section "Neovim Installer"
ensure_prereqs

install_packages neovim
copy_config_dir "nvim" "nvim"

read -rp "Install optional Neovim extras (lazygit + pywal)? (Y/n): " extras
if [[ "${extras:-y}" =~ ^[Yy]$ ]]; then
	install_packages lazygit python-pywal16
	apply_default_pywal
fi

success "Neovim component installed."
