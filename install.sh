#!/usr/bin/env bash
set -e

echo "📦 Updating system packages..."
sudo pacman -Syu --noconfirm

# --- User Setup ---
if ! id -u eagle &>/dev/null; then
    echo "👤 Creating main user 'eagle'..."
    sudo useradd -m -G wheel -s /usr/bin/zsh eagle
    echo "Set password for 'eagle':"
    sudo passwd eagle
fi

# Enable sudo for wheel group
if ! sudo grep -q '^%wheel' /etc/sudoers; then
    echo "%wheel ALL=(ALL) ALL" | sudo tee -a /etc/sudoers >/dev/null
fi

# --- AUR Helper ---
if ! command -v yay &>/dev/null; then
    echo "📦 Installing yay..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd .. && rm -rf yay
fi

# --- Core Packages ---
PACKAGES=(
    hyprland waybar swaync rofi-wayland kitty
    neovim stow btop thunar pavucontrol
    grim slurp swww hyprshade cliphist
    sudo linux linux-headers networkmanager dhcpcd
    greetd greetd-tuigreet pipewire-alsa pipewire-jack pipewire-pulse
    wireplumber zsh zsh-autosuggestions zsh-syntax-highlighting
    ttf-font-awesome ttf-nerd-fonts-symbols-common
    ttf-meslo-nerd ttf-jetbrains-mono-nerd gnome-themes-extra
)
# NVIDIA optional
if lspci | grep -iq nvidia; then
    PACKAGES+=( nvidia-open-dkms libva-nvidia-driver xdg-desktop-portal-hyprland qt5-wayland qt6-wayland )
fi

yay -S --needed --noconfirm "${PACKAGES[@]}"

# --- Stow Configs ---
echo "🔗 Linking configurations..."
cd ~/dotfiles
for dir in hypr kitty nvim rofi swaync waybar fastfetch zsh systemd greetd; do
    target=~/.config/$dir
    [ -d "$target" ] && [ ! -L "$target" ] && rm -rf "$target"
    stow -R -t ~ "$dir"
done

# --- Zsh Default Shell ---
if [[ $SHELL != "/usr/bin/zsh" ]]; then
    chsh -s $(which zsh)
fi

# --- Greetd Config ---
sudo mkdir -p /etc/greetd
sudo stow -t /etc greetd

# --- Enable Services ---
SERVICES=( greetd NetworkManager udisks2 systemd-timesyncd )
for svc in "${SERVICES[@]}"; do
    sudo systemctl enable "$svc"
done

# NVIDIA optional services
for svc in nvidia-hibernate.service nvidia-resume.service nvidia-suspend.service; do
    if systemctl list-unit-files | grep -q "$svc"; then
        sudo systemctl enable "$svc"
    fi
done

# Add greeter to video group
sudo usermod -aG video greeter

echo "✅ Setup Complete! Reboot recommended."
