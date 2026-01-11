function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases

    # ─────────────────────────────
    # Arch Linux aliases
    # ─────────────────────────────
     # ─────────────────────────────
    # Arch Linux package management
    # ─────────────────────────────

    # Base pacman shortcut
    alias p      'sudo pacman'          # Run pacman with sudo

    # Install packages from official repos
    alias pi     'sudo pacman -S'        # Install package(s)

    # Full system upgrade (IMPORTANT)
    alias pu     'sudo pacman -Syu'      # Update system

    # Remove package with configs and unused deps
    alias pr     'sudo pacman -Rns'      # Remove package completely

    # Search packages in repos
    alias ps     'pacman -Ss'            # Search available packages

    # Search installed packages
    alias pq     'pacman -Qs'            # Search installed packages

    # List files installed by a package
    alias pl     'pacman -Ql'            # Show package file list

    # Clean old cached packages
    alias pc     'sudo pacman -Sc'       # Clean pacman cache

    # ─────────────────────────────
    # AUR helper (yay)
    # ─────────────────────────────

    # Install AUR or repo packages
    alias yi     'yay -S'                # Install AUR package

    # Update system including AUR
    alias yu     'yay -Syu'              # Full repo + AUR update

    # Remove AUR package with deps
    alias yr     'yay -Rns'              # Remove AUR package

    # Search AUR and repos
    alias ys     'yay -Ss'               # Search AUR

    # Search installed AUR packages
    alias yq     'yay -Qs'               # Search installed AUR packages

    # Clean yay cache
    alias yc     'yay -Sc'               # Clean yay cache

    # ─────────────────────────────
    # System control
    # ─────────────────────────────

    alias reboot   'systemctl reboot'    # Reboot system
    alias shutdown 'systemctl poweroff'  # Power off system
    alias suspend  'systemctl suspend'   # Suspend / sleep
    alias lock     'loginctl lock-session' # Lock session

    # ─────────────────────────────
    # Files and navigation
    # ─────────────────────────────

    alias ls    'eza --icons'             # Modern ls with icons
    alias ll    'eza -lh --icons'         # Long list with sizes
    alias la    'eza -lah --icons'        # List all (incl. hidden)
    alias tree  'eza --tree --icons'      # Directory tree view

    # ─────────────────────────────
    # Quality of life
    # ─────────────────────────────

    # Clear terminal and scrollback buffer
    alias clear "printf '\033[2J\033[3J\033[1;1H'"

    # Quickshell shortcut
    alias q 'qs -c ii'

end
