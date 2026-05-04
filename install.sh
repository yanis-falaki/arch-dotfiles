#################### Git
echo "Installing git..."
sudo pacman -S git
####################

#################### YAY (AUR Helper)
echo "Installing prebuilt yay AUR helper..."

cd downloads
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
sudo pacman -S base-devel
makepkg -si
cd ../..
######################

echo "Installing hyprland..."
sudo pacman -S hyprland

echo "Installing kitty..."
sudo pacman -S kitty

echo "Installing NVIDIA related packages.."
sudo pacman -S nvidia-utils nvidia-open-dkms linux-firmware-nvidia

echo "Installing egl-wayland..."
sudo pacman -S egl-wayland

# Enable modeset as per hyprland docs
if [[ ! -f "/etc/modprobe.d/nvidia.conf" ]]; then
	sudo -sh -c 'echo "options nvidia_drm modeset=1" >> /etc/modprobe.d/nvidia.conf'
fi

echo "Installing nvidia-linux headers..."
sudo pacman -S linux-headers 

# TODO: Add MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm ...) to appropriate place in /etc/mkinitcpio.conf
# 	After which rebuilt intramfs with `sudo mkinitcpio -P` and reboot
