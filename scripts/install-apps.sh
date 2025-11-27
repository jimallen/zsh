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

ZEN_BACKUP="$SCRIPT_DIR/zen-essentials.tar.gz"
ZEN_DIR="$HOME/.zen"

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

# =============================================================================
# MAIN
# =============================================================================

show_help() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --apps-only     Install applications only (skip Zen restore)"
    echo "  --zen-only      Restore Zen profile only (skip app installation)"
    echo "  --force         Overwrite existing Zen profile if it exists"
    echo "  --help          Show this help message"
    echo ""
    echo "With no options, installs all apps and restores Zen profile (skips if exists)."
}

main() {
    local install_apps=true
    local restore_zen=true
    local force=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --apps-only)
                restore_zen=false
                shift
                ;;
            --zen-only)
                install_apps=false
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

    if [[ "$restore_zen" == true ]]; then
        restore_zen_profile "$force"
        echo ""
    fi

    print_info "Setup complete!"
}

# Run main function
main "$@"
