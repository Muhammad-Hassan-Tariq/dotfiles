#!/usr/bin/env bash

# --- Arch Linux Automated Setup Script for Hassan --- #
# Logic: Install AUR helper -> Install Packages -> Stow Configs

echo "🚀 Starting the Great Restoration..."

# 1. Install Yay (AUR Helper) if not present
if ! command -v yay &> /dev/null; then
    echo "📦 Installing yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd .. && rm -rf yay
fi

# 2. Update System
yay -Syu --noconfirm

# 3. Install Technical Stack & Rice Components
echo "🛠️ Installing Core Packages..."
PACKAGES=(
    "hyprland" "hyprshade" "waybar" "swaync" "rofi-wayland" "kitty" 
    "neovim" "stow" "btop" "thunar" "pavucontrol" "brightnessctl"
    "bluez" "bluez-utils" "networkmanager" "grim" "slurp" # Screenshot tools
    "ttf-font-awesome" "otf-font-awesome" "ttf-nerd-fonts-symbols-common" # Icons!
)

yay -S --noconfirm "${PACKAGES[@]}"

# 4. Symbolic Link Magic with GNU Stow
echo "🔗 Linking configurations..."
cd ~/dotfiles
# This loop stows every folder in your dotfiles directory
for dir in */; do
    stow -t ~ "$dir"
    echo "✅ Stowed $dir"
done

echo "🥋 Setup Complete, Hassan! Your system is now 'A-Class'."
echo "🔄 Rebooting is recommended."
