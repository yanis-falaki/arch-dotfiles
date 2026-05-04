#!/bin/bash
# =============================================================================
#  Dotfiles Installer — by EF
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}${BOLD}[•]${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}[✓]${RESET} $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[!]${RESET} $*"; }
error()   { echo -e "${RED}${BOLD}[✗]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}\n"; }

# ── Banner ────────────────────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
cat << 'EOF'
  ____        _    __ _ _
 |  _ \  ___ | |_ / _(_) | ___  ___
 | | | |/ _ \| __| |_| | |/ _ \/ __|
 | |_| | (_) | |_|  _| | |  __/\__ \
 |____/ \___/ \__|_| |_|_|\___||___/

EOF
echo -e "${RESET}"

# ── Sanity checks ─────────────────────────────────────────────────────────────
DOTFILES_DIR="$HOME/Dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR. Aborting."
    exit 1
fi

if ! command -v yay &>/dev/null; then
    error "'yay' AUR helper not found. Please install it first."
    exit 1
fi

# ── Shared helpers ────────────────────────────────────────────────────────────

backup_config() {
    local backup_path="${HOME}/.config_backup_$(date +%Y%m%d_%H%M%S)"
    info "Backing up ~/.config → $backup_path"
    cp -r "$HOME/.config" "$backup_path"
    success "Backup created at $backup_path"
}

apply_dotfiles() {
    section "Applying Dotfiles"
    info "Copying wallpapers..."
    cp -a "$DOTFILES_DIR/wallpapers" "$HOME/"

    info "Copying .config files..."
    cp -a "$DOTFILES_DIR/.config/." "$HOME/.config/"

    info "Copying .bashrc..."
    cp -a "$DOTFILES_DIR/.bashrc" "$HOME/"

    fix_wofi_paths
    success "Dotfiles applied."
}

fix_wofi_paths() {
    local config_dir="$HOME/.config/wofi"

    if [ ! -d "$config_dir" ]; then
        warn "Wofi config directory not found at $config_dir — skipping path fix."
        return
    fi

    info "Fixing wofi CSS paths for user: $USER"
    find "$config_dir" -maxdepth 1 -type f -name "*.css" -print0 \
    | while IFS= read -r -d '' file; do
        sed -i -E \
            "s|/home/[^/]+/\.cache/wal/colors-waybar\.css|$HOME/.cache/wal/colors-waybar.css|g" \
            "$file"
        success "Updated: $file"
    done
}

setup_wallpaper() {
    section "Setting Wallpaper (pywal)"
    local wallpaper="$DOTFILES_DIR/wallpapers/pywallpaper.jpg"
    if [ -f "$wallpaper" ]; then
        wal -i "$wallpaper" -n
        success "Wallpaper set."
    else
        warn "Wallpaper not found at $wallpaper — skipping."
    fi
}

setup_dynamic_cursors() {
    section "Dynamic Cursors"
    if hyprpm add https://github.com/virtcode/hypr-dynamic-cursors && \
       hyprpm enable dynamic-cursors; then
        success "Dynamic cursors enabled."
    else
        warn "Dynamic cursors setup failed — you may need to run this manually."
    fi
}

setup_mirrors() {
    section "Updating Pacman Mirrorlist"
    yay -S --needed reflector rsync
    sudo reflector --country 'US' --latest 10 --sort rate \
        --save /etc/pacman.d/mirrorlist
    success "Mirrorlist updated."
}

setup_bluetooth() {
    section "Bluetooth"
    yay -S --needed blueman bluez
    sudo systemctl enable --now bluetooth
    success "Bluetooth enabled."
}

setup_pipewire() {
    section "Pipewire & Audio"
    yay -S --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack \
        pavucontrol pulsemixer gnome-network-displays gst-plugins-bad
    systemctl --user enable --now pipewire.service
    systemctl --user enable --now pipewire-pulse.service
    success "Pipewire configured."
}

finish() {
    success "Installation complete! 🎉"
    notify-send \
        "Dotfiles Installed" \
        "Open Terminal with MOD+Q\nHello $USER — Thanks for using my Dotfiles!\n-EF" \
        2>/dev/null || true
}

# ── Core packages ─────────────────────────────────────────────────────────────
CORE_PACKAGES=(
    python-pywal16 swww waybar swaync starship myfetch neovim python-pywalfox
    hypridle hyprpicker hyprshot hyprlock hyprmon pacman-contrib pyprland wlogout fd
    cava brightnessctl clock-rs-git nerd-fonts nwg-look qogir-icon-theme
    materia-gtk-theme illogical-impulse-bibata-modern-classic-bin
    thunar gvfs tumbler eza bottom htop libreoffice-fresh spotify-launcher ncspot
    discord visual-studio-code-bin
)

OPTIONAL_PACKAGES=(blueman bluez pipewire pipewire-pulse pipewire-alsa
    pipewire-jack pavucontrol pulsemixer gnome-network-displays gst-plugins-bad)

# ── Installation modes ────────────────────────────────────────────────────────

auto_install() {
    section "Automatic Installation"

    setup_mirrors

    info "Installing all packages..."
    yay -S --needed "${CORE_PACKAGES[@]}"
    success "Core packages installed."

    sudo systemctl enable --now avahi-daemon

    setup_bluetooth
    setup_pipewire
    setup_wallpaper
    setup_dynamic_cursors
    apply_dotfiles
    finish
}

manual_install() {
    section "Manual Installation"

    read -rp "Update mirrorlist for best US servers? (Y/n): " m
    [[ "${m:-y}" =~ ^[Yy]$ ]] && setup_mirrors

    section "Package Selection"
    for pkg in "${CORE_PACKAGES[@]}"; do
        read -rp "  Install ${BOLD}${pkg}${RESET}? (Y/n): " choice
        [[ "${choice:-y}" =~ ^[Yy]$ ]] && yay -S --needed "$pkg" && clear
    done

    setup_wallpaper

    read -rp "Install Bluetooth support? (Y/n): " b
    [[ "${b:-y}" =~ ^[Yy]$ ]] && setup_bluetooth

    read -rp "Configure Pipewire & Network Displays? (Y/n): " p
    [[ "${p:-y}" =~ ^[Yy]$ ]] && setup_pipewire

    read -rp "Enable Dynamic Cursors? (Y/n): " c
    [[ "${c:-y}" =~ ^[Yy]$ ]] && setup_dynamic_cursors

    apply_dotfiles
    finish
}

# ── Entry point ───────────────────────────────────────────────────────────────

section "Welcome"

read -rp "Installation mode — (A)utomatic or (M)anual? [A]: " install_choice
install_choice="${install_choice:-a}"

read -rp "Backup your current ~/.config before installing? (Y/n): " backup_choice
[[ "${backup_choice:-y}" =~ ^[Yy]$ ]] && backup_config

case "${install_choice,,}" in
    a) auto_install  ;;
    m) manual_install ;;
    *) error "Unknown option '$install_choice'. Exiting."; exit 1 ;;
esac
