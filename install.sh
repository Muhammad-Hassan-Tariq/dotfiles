#!/usr/bin/env bash
set -e

# --- Arch Linux Automated Setup Script for Hassan --- #
# Technical Stack: Hyprland, Zsh, NVIDIA, Greetd, STM32-Ready
# Logic: Install AUR helper -> Install Packages -> Stow Configs -> Setup Greetd

# 0️⃣ Ensure main user exists and has sudo privileges
if ! id -u eagle &>/dev/null; then
    echo "👤 Creating main user 'eagle'..."
    sudo useradd -m -G wheel -s /usr/bin/zsh eagle
    echo "Set password for 'eagle':"
    sudo passwd eagle
fi

# Enable sudo for wheel group (if not already)
if ! sudo grep -q '^%wheel' /etc/sudoers; then
    echo "🔧 Configuring sudoers for wheel group..."
    echo "%wheel ALL=(ALL) ALL" | sudo tee -a /etc/sudoers >/dev/null
fi

echo "📦 Updating system packages..."
sudo pacman -Syu --noconfirm
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
  hyprland waybar swaync rofi-wayland kitty
  neovim stow btop thunar pavucontrol
  grim slurp swww hyprshade cliphist
  sudo linux linux-headers networkmanager dhcpcd
  nvidia-open-dkms libva-nvidia-driver xdg-desktop-portal-hyprland qt5-wayland qt6-wayland
  greetd greetd-tuigreet pipewire-alsa pipewire-jack pipewire-pulse
  wireplumber zsh zsh-autosuggestions zsh-syntax-highlighting ttf-font-awesome
  ttf-nerd-fonts-symbols-common ttf-meslo-nerd ttf-jetbrains-mono-nerd gnome-themes-extra
)

yay -S --needed --noconfirm "${PACKAGES[@]}"

# 4. Symbolic Link Magic with GNU Stow 🔗
echo "🔗 Linking configurations..."
cd ~/dotfiles

# Pre-cleanup: Remove default directories to prevent Stow conflicts
[ -d ~/.config/hypr ] && [ ! -L ~/.config/hypr ] && rm -rf ~/.config/hypr

for dir in hypr kitty nvim rofi swaync waybar fastfetch zsh systemd; do
  stow -R -t ~ "$dir"
done

# 5. Set Zsh as default shell 🐚
if [[ $SHELL != "/usr/bin/zsh" ]]; then
  echo "Switching to Zsh..."
  chsh -s $(which zsh)
fi

# 6. Configure the Front Door (greetd) 🚪
echo "📝 Writing greetd configuration..."
sudo mkdir -p /etc/greetd
sudo stow -t /etc greetd

# 7. Enabling the "Engine" (Services) ⚙️
echo "⚡ Activating system services..."

# Essential Services
sudo systemctl enable greetd.service
sudo systemctl enable NetworkManager.service # Optimized for Hyprland usage 🌐
sudo systemctl enable udisks2.service
sudo systemctl enable systemd-timesyncd.service

for svc in nvidia-hibernate.service nvidia-resume.service nvidia-suspend.service; do
  if systemctl list-unit-files | grep -q "$svc"; then
    sudo systemctl enable "$svc"
  fi
done

# Access Rights for the Greeter 🎮
sudo usermod -aG video greeter

echo "✅ Services enabled!"
echo "Setup Complete, Hassan! System is now 'A-Class'."
echo "🔄 Rebooting is recommended."
