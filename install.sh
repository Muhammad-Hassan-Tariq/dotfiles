#!/usr/bin/env bash

# --- Arch Linux Automated Setup Script for Hassan --- #
# Technical Stack: Hyprland, Zsh, NVIDIA, Greetd, STM32-Ready
# Logic: Install AUR helper -> Install Packages -> Stow Configs -> Setup Greetd

echo "Starting the Great Restoration..."

# 1. Install Yay (AUR Helper) if not present
if ! command -v yay &>/dev/null; then
  echo "📦 Installing yay..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay && makepkg -si --noconfirm
  cd .. && rm -rf yay
fi

# 2. Update System 🔄
yay -Syu --noconfirm

# 3. Install Verified Technical Stack & Rice Components
echo "Installing Core Packages..."
PACKAGES=(
  # Verified UI & Rice 🎨
  "hyprland" "waybar" "swaync" "rofi-wayland" "kitty" "neovim" "stow"
  "btop" "thunar" "pavucontrol" "grim" "slurp" "swww" "hyprshade"
  "cliphist" "nwg-look" "adw-gtk-theme" "papirus-icon-theme"

  # System & Drivers
  "networkmanager" "dhcpcd" "nvidia-open-dkms" "libva-nvidia-driver"
  "xdg-desktop-portal-hyprland" "qt5-wayland" "qt6-wayland" "greetd"
  "greetd-tuigreet" # AUR frontend for greetd

  # Shell & Fonts
  "zsh" "zsh-autosuggestions" "zsh-syntax-highlighting"
  "ttf-font-awesome" "ttf-nerd-fonts-symbols-common"
)

yay -S --needed --noconfirm "${PACKAGES[@]}"

# 4. Symbolic Link Magic with GNU Stow 🔗
echo "🔗 Linking configurations..."
cd ~/dotfiles

# Pre-cleanup: Remove default directories to prevent Stow conflicts
[ -d ~/.config/hypr ] && [ ! -L ~/.config/hypr ] && rm -rf ~/.config/hypr

for dir in */; do
  dir=${dir%/} # Strip trailing slash
  if [[ "$dir" != "yay" ]]; then
    stow -R -t ~ "$dir"
    echo "✅ Stowed $dir"
  fi
done

# 5. Set Zsh as default shell 🐚
if [[ $SHELL != "/usr/bin/zsh" ]]; then
  echo "Switching to Zsh..."
  chsh -s $(which zsh)
fi

# 6. Configure the Front Door (greetd) 🚪
echo "📝 Writing greetd configuration..."
sudo mkdir -p /etc/greetd
sudo tee /etc/greetd/config.toml >/dev/null <<EOF
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd Hyprland"
user = "greeter"
EOF

# 7. Enabling the "Engine" (Services) ⚙️
echo "⚡ Activating system services..."

# Essential Services
sudo systemctl enable greetd.service
sudo systemctl enable NetworkManager.service # Optimized for Hyprland usage 🌐
sudo systemctl enable udisks2.service
sudo systemctl enable systemd-timesyncd.service

# NVIDIA Power Management
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
sudo systemctl enable nvidia-suspend.service

# Access Rights for the Greeter 🎮
sudo usermod -aG video greeter

echo "✅ Services enabled!"
echo "Setup Complete, Hassan! System is now 'A-Class'."
echo "🔄 Rebooting is recommended."
