# Noir-dots

<div align="center">
  <p><b>A custom Hyprland Setup blending End-4 stability with Noctalia aesthetics.</b></p>
</div>

---

## 📖 About
**Noir-dots** is a highly customized Hyprland configuration for Arch Linux. It is built upon the robust foundation of **[End-4's dots-hyprland](https://github.com/end-4/dots-hyprland)** and features the beautiful **[Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)** (Quickshell). 

This repository provides a fully automated installation script that handles system dependencies, theming, and configuration management.

## ✨ Features
* **Base System:** Powered by End-4's Hyprland dotfiles (Waybar, Hyprland, drivers).
* **Shell:** Integrated **Noctalia Shell** (Quickshell) for a modern desktop experience.
* **Smart Merging:** The installer preserves the official Noctalia theme while applying my custom tweaks seamlessly.
* **Auto-Backup:** Existing configurations in `~/.config` are automatically backed up before installation—no data loss.

## 📦 Prerequisites
* **OS:** Arch Linux (or Arch-based distro).
* **Package Manager:** `pacman` (The script automatically installs `yay` if missing).
* **Git:** Required to clone the repository.

## 🚀 Installation

The included `install.sh` script automates the entire process. It will:
1.  Install system dependencies (End-4 base).
2.  Install Noctalia Shell & Theme.
3.  Deploy **Noir-dots** configurations.

### 1. Clone the Repository
```bash
git clone https://github.com/Ronin-CK/Noir-dots.git
cd Noir-dots
```

### 2. Run the Installer
```bash
chmod +x install.sh
./install.sh
```
Once the script finishes:

  - Reboot your system.
  - Select Hyprland from your login manager (if not already selected).

## Credits

This repository is a personal configuration inspired by and adapted from:

- [Nocturnal-Shell](https://github.com/noctalia-dev/noctalia-shell)
- [end-4 dotfiles](https://github.com/end-4/dots-hyprland)

All configurations have been modified for personal use.
This repository is not affiliated with the original authors.
