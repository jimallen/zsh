#!/bin/bash
#
# Application Installer Script
# Maintainable script for installing applications via paru (AUR helper)
# Also restores Zen browser profile from backup
#

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# =============================================================================
# CONFIGURATION
# =============================================================================

ZSH_REPO_DIR="$(dirname "$SCRIPT_DIR")"
ZEN_BACKUP="$SCRIPT_DIR/zen-essentials.tar.gz"
ZEN_DIR="$HOME/.zen"
OMZ_DIR="$HOME/.oh-my-zsh"

# =============================================================================
# APPLICATION LIST
# Add or remove applications here
# =============================================================================

AUR_APPS=(
    "google-chrome"
    "slack-desktop"
    "wasistlos"
    "claude-desktop-native"
    "github-cli"
    "zen-browser-bin"
)

# =============================================================================
# FUNCTIONS
# =============================================================================

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_paru() {
    if ! command -v paru &> /dev/null; then
        print_error "paru is not installed. Please install paru first."
        exit 1
    fi
}

is_installed() {
    paru -Qi "$1" &> /dev/null
}

install_app() {
    local app="$1"

    if is_installed "$app"; then
        print_warn "$app is already installed, skipping..."
    else
        print_info "Installing $app..."
        paru -S --noconfirm "$app"
        print_info "$app installed successfully"
    fi
}

restore_zen_profile() {
    local force="$1"

    if [[ ! -f "$ZEN_BACKUP" ]]; then
        print_error "Zen backup not found at $ZEN_BACKUP"
        return 1
    fi

    if [[ -d "$ZEN_DIR" ]]; then
        if [[ "$force" != true ]]; then
            print_warn "Zen profile directory already exists at $ZEN_DIR"
            print_info "Skipping Zen profile restore (use --force to overwrite)"
            return 0
        fi
        print_info "Backing up existing profile to ${ZEN_DIR}.bak"
        rm -rf "${ZEN_DIR}.bak"
        mv "$ZEN_DIR" "${ZEN_DIR}.bak"
    fi

    print_info "Restoring Zen browser profile..."
    mkdir -p "$ZEN_DIR"
    tar -xzf "$ZEN_BACKUP" -C "$ZEN_DIR" --strip-components=0
    print_info "Zen profile restored successfully"
    print_warn "Note: Extensions will need to be reinstalled on first launch"
}

setup_zsh() {
    local force="$1"

    print_info "Setting up Zsh configuration..."

    # Install Oh My Zsh if not present
    if [[ ! -d "$OMZ_DIR" ]]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        print_info "Oh My Zsh already installed"
    fi

    # Install Powerlevel10k theme
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        print_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    else
        print_info "Powerlevel10k already installed"
    fi

    # Symlink .zshrc
    if [[ -L "$HOME/.zshrc" ]]; then
        local current_target
        current_target=$(readlink "$HOME/.zshrc")
        if [[ "$current_target" == "$ZSH_REPO_DIR/.zshrc" || "$current_target" == "zsh/.zshrc" ]]; then
            print_info ".zshrc symlink already correct"
        else
            if [[ "$force" == true ]]; then
                print_info "Updating .zshrc symlink..."
                ln -sf "$ZSH_REPO_DIR/.zshrc" "$HOME/.zshrc"
            else
                print_warn ".zshrc symlink points elsewhere: $current_target"
                print_info "Use --force to overwrite"
            fi
        fi
    elif [[ -f "$HOME/.zshrc" ]]; then
        if [[ "$force" == true ]]; then
            print_info "Backing up existing .zshrc to .zshrc.bak"
            mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
            ln -s "$ZSH_REPO_DIR/.zshrc" "$HOME/.zshrc"
            print_info ".zshrc symlinked"
        else
            print_warn ".zshrc exists and is not a symlink"
            print_info "Use --force to backup and replace"
        fi
    else
        ln -s "$ZSH_REPO_DIR/.zshrc" "$HOME/.zshrc"
        print_info ".zshrc symlinked"
    fi

    # Symlink .p10k.zsh
    if [[ -f "$ZSH_REPO_DIR/.p10k.zsh" ]]; then
        if [[ -L "$HOME/.p10k.zsh" ]]; then
            print_info ".p10k.zsh symlink already exists"
        elif [[ -f "$HOME/.p10k.zsh" ]]; then
            if [[ "$force" == true ]]; then
                print_info "Backing up existing .p10k.zsh to .p10k.zsh.bak"
                mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
                ln -s "$ZSH_REPO_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
                print_info ".p10k.zsh symlinked"
            else
                print_warn ".p10k.zsh exists and is not a symlink"
                print_info "Use --force to backup and replace"
            fi
        else
            ln -s "$ZSH_REPO_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
            print_info ".p10k.zsh symlinked"
        fi
    fi

    print_info "Zsh setup complete"
}

# =============================================================================
# MAIN
# =============================================================================

show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --apps-only     Install applications only"
    echo "  --zen-only      Restore Zen profile only"
    echo "  --zsh-only      Setup Zsh only (Oh My Zsh, Powerlevel10k, symlinks)"
    echo "  --force         Overwrite existing files/profiles"
    echo "  --help          Show this help message"
    echo ""
    echo "With no options, runs full setup: apps, Zsh config, and Zen profile."
}

main() {
    local install_apps=true
    local setup_zsh_config=true
    local restore_zen=true
    local force=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --apps-only)
                setup_zsh_config=false
                restore_zen=false
                shift
                ;;
            --zen-only)
                install_apps=false
                setup_zsh_config=false
                shift
                ;;
            --zsh-only)
                install_apps=false
                restore_zen=false
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    print_info "Starting setup..."
    echo ""

    if [[ "$install_apps" == true ]]; then
        check_paru

        for app in "${AUR_APPS[@]}"; do
            install_app "$app"
            echo ""
        done
    fi

    if [[ "$setup_zsh_config" == true ]]; then
        setup_zsh "$force"
        echo ""
    fi

    if [[ "$restore_zen" == true ]]; then
        restore_zen_profile "$force"
        echo ""
    fi

    print_info "Setup complete!"
}

# Run main function
main "$@"
