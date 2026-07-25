#!/usr/bin/env bash
set -e

# Dolphin Davinci Audio Tools Installation Script
# Supports Ubuntu/Debian automatic installation, provides manual instructions for other distros

REQUIRED=(ffmpeg zenity notify-send bc)
MISSING=()
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_DIR="$HOME/.local/share/kio/servicemenus"
SCRIPT_DEST_DIR="$HOME/.local/share/dolphin-davinci-audio-tools"

echo "=== Dolphin Davinci Audio Tools Installation ==="
echo

# Function to detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Function to show distro-specific installation commands
show_distro_commands() {
    local distro=$(detect_distro)
    echo
    echo "For your distribution ($distro), install dependencies manually:"
    echo
    case "$distro" in
    ubuntu | debian | linuxmint | pop)
        echo "sudo apt update"
        echo "sudo apt install ffmpeg zenity libnotify-bin bc"
        ;;
    fedora | centos | rhel)
        echo "sudo dnf install ffmpeg zenity libnotify bc"
        ;;
    arch | manjaro)
        echo "sudo pacman -S ffmpeg zenity libnotify bc"
        ;;
    opensuse*)
        echo "sudo zypper install ffmpeg zenity libnotify-tools bc"
        ;;
    *)
        echo "Please install these packages using your distribution's package manager:"
        echo "- ffmpeg"
        echo "- zenity"
        echo "- libnotify (or equivalent providing notify-send)"
        echo "- bc"
        ;;
    esac
    echo
}

echo "Checking dependencies..."
for cmd in "${REQUIRED[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        MISSING+=("$cmd")
    fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
    echo "Missing dependencies: ${MISSING[*]}"
    echo

    distro=$(detect_distro)

    # Offer automatic installation for Ubuntu/Debian and Arch Linux systems
    if [[ "$distro" =~ ^(ubuntu|debian|linuxmint|pop)$ ]]; then
        read -p "Install missing packages now? [y/N] " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            echo "Installing missing packages..."
            sudo apt update
            sudo apt install -y "${MISSING[@]}" || {
                echo "Failed to install dependencies. Please install manually:"
                show_distro_commands
                exit 1
            }
            echo "Dependencies installed successfully."
        else
            echo "Please install dependencies before continuing."
            show_distro_commands
            exit 1
        fi
    elif [[ "$distro" =~ ^(arch|manjaro|endeavouros|garuda)$ ]]; then
        read -p "Install missing packages now? [y/N] " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            echo "Installing missing packages..."
            # Map command names to Arch package names
            ARCH_PACKAGES=()
            for cmd in "${MISSING[@]}"; do
                case "$cmd" in
                "notify-send")
                    ARCH_PACKAGES+=("libnotify")
                    ;;
                *)
                    ARCH_PACKAGES+=("$cmd")
                    ;;
                esac
            done

            sudo pacman -Sy "${ARCH_PACKAGES[@]}" || {
                echo "Failed to install dependencies. Please install manually:"
                show_distro_commands
                exit 1
            }
            echo "Dependencies installed successfully."
        else
            echo "Please install dependencies before continuing."
            show_distro_commands
            exit 1
        fi
    else
        echo "Automatic installation is supported on Ubuntu/Debian and Arch Linux systems."
        show_distro_commands
        read -p "Have you installed the dependencies and want to continue? [y/N] " yn
        if [[ ! "$yn" =~ ^[Yy]$ ]]; then
            echo "Please install dependencies before running the installer."
            exit 1
        fi
    fi
else
    echo "All dependencies found: ${REQUIRED[*]}"
fi

echo
echo "Installing Dolphin service menus..."

# Create service menu directory
mkdir -p "$SERVICE_DIR"

# Copy and make executable service menu files
if [ -f "$SCRIPT_DIR/servicemenus/dolphin-davinci-conversions.desktop" ]; then
    cp "$SCRIPT_DIR/servicemenus/dolphin-davinci-conversions.desktop" "$SERVICE_DIR/"
    chmod +x "$SERVICE_DIR/dolphin-davinci-conversions.desktop"
    echo "✓ Service menu installed to $SERVICE_DIR"
else
    echo "Error: Service menu file not found at $SCRIPT_DIR/servicemenus/dolphin-davinci-conversions.desktop"
    exit 1
fi

echo
echo "Installing conversion scripts..."

# Create scripts directory
mkdir -p "$SCRIPT_DEST_DIR"

# Copy all script files
script_files=(
    "aac2flac_replace"
    "aac2flac_mkv"
    "aac2wav_replace"
    "toaac_replace"
    "toaac_mp4"
    "to_davinci_resolve_replace"
    "to_davinci_resolve_mov"
)

for script in "${script_files[@]}"; do
    if [ -f "$SCRIPT_DIR/scripts/$script" ]; then
        cp "$SCRIPT_DIR/scripts/$script" "$SCRIPT_DEST_DIR/"
        chmod +x "$SCRIPT_DEST_DIR/$script"
        echo "✓ Script installed: $script"
    else
        echo "Warning: Script file not found: $SCRIPT_DIR/scripts/$script"
    fi
done

# Update service menu file with correct script paths
if [ -f "$SERVICE_DIR/dolphin-davinci-conversions.desktop" ]; then
    # Replace placeholder paths with actual installation paths
    sed -i "s|/path/to/scripts|$SCRIPT_DEST_DIR|g" "$SERVICE_DIR/dolphin-davinci-conversions.desktop"
    echo "✓ Updated service menu paths"
fi

echo
echo "=== Installation Complete ==="
echo
echo "Installation successful! Dolphin Davinci Audio Tools has been installed."
echo
echo "To use the service menus:"
echo "1. Restart Dolphin (or open a new Dolphin window)"
echo "2. Right-click on any video or audio file"
echo "3. Select 'Davinci Resolve Conversions' from the context menu"
echo
echo "Files have been installed to:"
echo "• Service menus: $SERVICE_DIR"
echo "• Scripts: $SCRIPT_DEST_DIR"
echo
echo "For troubleshooting, see the README.md file."
echo "To uninstall, run: ./uninstall.sh"
echo

# Validate the service menu file
if command -v desktop-file-validate >/dev/null 2>&1; then
    echo "Validating service menu file..."
    if desktop-file-validate "$SERVICE_DIR/dolphin-davinci-conversions.desktop" 2>/dev/null; then
        echo "✓ Service menu file validation passed"
    else
        echo "ℹ Service menu validation shows expected warnings"
        echo "  (KDE service menus use different standards than regular .desktop files)"
        echo "  These warnings are normal and don't affect functionality"
    fi
fi

echo "Installation finished. Enjoy using Dolphin Davinci Audio Tools!"
