# --- Arch Linux Automated Setup Script for Hassan --- #
# Logic: Install AUR helper -> Install Packages -> Stow Configs

echo "🚀 Starting the Great Restoration..."

# 1. Install Yay (AUR Helper) if not present
if ! command -v yay &>/dev/null; then
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
  "hyprland" "waybar" "swaync" "rofi-wayland" "kitty"
  "neovim" "stow" "btop" "thunar" "pavucontrol" "brightnessctl"
  "bluez" "bluez-utils" "networkmanager" "grim" "slurp"
  "ttf-font-awesome" "otf-font-awesome" "ttf-nerd-fonts-symbols-common"
  "nwg-look" "adw-gtk-theme" "papirus-icon-theme"
  "swww" "hyprshade" "cliphist" "wl-clipboard"
  "xdg-desktop-portal-hyprland" "qt5-wayland" "qt6-wayland"
  "nvidia-open-dkms" "libva-nvidia-driver"              # Hassan's GPU Power! 🏎️
  "zsh" "zsh-autosuggestions" "zsh-syntax-highlighting" # The Brain 🐚
)

yay -S --needed --noconfirm "${PACKAGES[@]}"

# 4. Symbolic Link Magic with GNU Stow
echo "🔗 Linking configurations..."
cd ~/dotfiles

# Pre-cleanup: Remove default directories to prevent Stow conflicts
# (Only if they aren't already symlinks!)
[ -d ~/.config/hypr ] && [ ! -L ~/.config/hypr ] && rm -rf ~/.config/hypr

for dir in */; do
  dir=${dir%/}                   # Remove trailing slash
  if [[ "$dir" != "yay" ]]; then # Don't stow the yay build folder
    stow -R -t ~ "$dir"
    echo "✅ Stowed $dir"
  fi
done

# 5. Set Zsh as default shell
if [[ $SHELL != "/usr/bin/zsh" ]]; then
  echo "🐚 Switching to Zsh..."
  chsh -s $(which zsh)
fi

echo "🥋 Setup Complete, Hassan! Your system is now 'A-Class'."
echo "🔄 Rebooting is recommended to load NVIDIA drivers and Zsh."
