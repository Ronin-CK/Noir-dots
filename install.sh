#!/bin/bash

# ==============================================================================
# MASTER INSTALLER: End-4 Base + Noctalia Shell + Noir-dots
# ==============================================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

TEMP_DIR="$HOME/Downloads/noir_install_temp"
MY_DOTS_URL="https://github.com/Ronin-CK/Noir-dots.git"
END4_URL="https://github.com/end-4/dots-hyprland"

echo -e "${BLUE}:: Initializing Master Installer ::${NC}"
mkdir -p "$TEMP_DIR"

check_yay() {
    if ! command -v yay &> /dev/null; then
        echo -e "${YELLOW}:: 'yay' not found. Installing yay-bin...${NC}"
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay-bin.git "$TEMP_DIR/yay-bin"
        cd "$TEMP_DIR/yay-bin" || exit
        makepkg -si --noconfirm
    else
        echo -e "${GREEN}:: 'yay' is already installed.${NC}"
    fi
}

install_end4() {
    echo -e "${BLUE}========================================================${NC}"
    echo -e "${BLUE} STEP 1: Installing End-4 Dotfiles (Base System)${NC}"
    echo -e "${BLUE}========================================================${NC}"

    if [ -d "$HOME/.config/hypr" ]; then
        echo -e "${YELLOW}:: Existing Hyprland config detected. Proceeding...${NC}"
    fi

    if [ ! -d "$TEMP_DIR/dots-hyprland" ]; then
        git clone "$END4_URL" "$TEMP_DIR/dots-hyprland"
    fi

    cd "$TEMP_DIR/dots-hyprland" || exit
    echo -e "${YELLOW}:: Launching End-4 installer... (Interact if prompted)${NC}"
    ./setup install
    echo -e "${GREEN}:: End-4 Base Installed.${NC}"
}

install_noctalia() {
    echo -e "${BLUE}========================================================${NC}"
    echo -e "${BLUE} STEP 2: Installing Noctalia Shell${NC}"
    echo -e "${BLUE}========================================================${NC}"

    check_yay
    echo -e "${BLUE}:: Installing Noctalia Dependencies...${NC}"
    yay -S --needed --noconfirm quickshell gpu-screen-recorder brightnessctl ddcutil \
    cliphist matugen-git cava wlsunset xdg-desktop-portal python3 evolution-data-server polkit-kde-agent

    echo -e "${BLUE}:: Installing Noctalia Theme...${NC}"
    mkdir -p "$HOME/.config/quickshell/noctalia-shell"
    curl -sL https://github.com/noctalia-dev/noctalia-shell/releases/latest/download/noctalia-latest.tar.gz | tar -xz --strip-components=1 -C "$HOME/.config/quickshell/noctalia-shell"

    echo -e "${GREEN}:: Noctalia Shell Installed.${NC}"
}

install_noirdots() {
    echo -e "${BLUE}========================================================${NC}"
    echo -e "${BLUE} STEP 3: Installing Your Configs (Noir-dots)${NC}"
    echo -e "${BLUE}========================================================${NC}"

    local INSTALL_DIR="$HOME/Noir-dots"
    local BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

    # 1. Clone your repo
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}:: Updating existing Noir-dots repo...${NC}"
        cd "$INSTALL_DIR" && git pull
    else
        git clone "$MY_DOTS_URL" "$INSTALL_DIR"
    fi

    # 2. Locate the config source
    # We check if your repo has a '.config' folder inside it
    local SOURCE_CONFIG="$INSTALL_DIR/.config"
    if [ ! -d "$SOURCE_CONFIG" ]; then
        # Fallback if no .config folder exists (assumes flat structure)
        SOURCE_CONFIG="$INSTALL_DIR"
    fi

    echo -e "${BLUE}:: Applying configs from $SOURCE_CONFIG...${NC}"
    mkdir -p "$BACKUP_DIR"

    # 3. Loop through your config folders
    find "$SOURCE_CONFIG" -maxdepth 1 -mindepth 1 -not -path '*/.*' | while read -r src; do
        name=$(basename "$src")

        # Skip repo metadata
        if [[ "$name" == "README.md" ]] || [[ "$name" == "LICENSE" ]] || [[ "$name" == "install.sh" ]] || [[ "$name" == ".git" ]]; then
            continue
        fi

        target="$HOME/.config/$name"

        # --- SPECIAL MERGE FOR QUICKSHELL ---
        if [[ "$name" == "quickshell" ]]; then
            echo -e "${YELLOW}:: Merging 'quickshell' (Overwriting your modified files only)...${NC}"

            # This copies your specific WallpaperService.qml over the stock one
            # -r: recursive
            # -f: force (overwrite)
            # -v: verbose (shows what is copied)
            cp -rfv "$src/"* "$target/"

            echo -e "${GREEN}:: Quickshell merged successfully.${NC}"

        # --- REPLACE FOR EVERYTHING ELSE ---
        else
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo -e "${YELLOW}:: Backing up existing $name -> $BACKUP_DIR/$name${NC}"
                mv "$target" "$BACKUP_DIR/$name"
            elif [ -L "$target" ]; then
                # Remove existing symlinks to avoid confusion
                rm "$target"
            fi

            # Create Symlink
            echo -e "${GREEN}:: Linking $name -> $target${NC}"
            ln -s "$src" "$target"
        fi
    done

    echo -e "${GREEN}:: Your dotfiles have been applied.${NC}"
}

# ------------------------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------------------------
echo -e "${RED}WARNING: This will modify your system configuration.${NC}"
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

check_yay
install_end4
install_noctalia
install_noirdots

echo -e "${BLUE}========================================================${NC}"
echo -e "${GREEN} INSTALLATION COMPLETE ${NC}"
echo -e "${YELLOW}Please reboot your system.${NC}"
