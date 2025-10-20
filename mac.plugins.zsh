##
## Plugins for macOS
##

# Configure and load plugins using Zinit's


##
## Installation Functions
##

# Function to install all required tools for macOS aliases
install_mac_tools() {
    echo "🍎 Installing tools required for macOS aliases..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    echo "📦 Installing core tools..."
    brew install eza bat  git-gui fzf
    
    echo "🔧 Installing additional useful tools..."
    brew install ripgrep fd jq tree htop
    
    echo "🎨 Installing development tools..."
    brew install node npm yarn
    
    echo "✅ Installation complete! You may need to restart your terminal or run 'source ~/.zshrc'"
    echo ""
    echo "📋 Installed tools:"
    echo "  • eza - Modern ls replacement"
    echo "  • bat - Modern cat replacement"
    echo "  • git - Version control"
    echo "  • git-gui - Git GUI tools (gitk)"
    echo "  • fzf - Fuzzy finder"
    echo "  • ripgrep - Fast grep replacement"
    echo "  • fd - Fast find replacement"
    echo "  • jq - JSON processor"
    echo "  • tree - Directory tree viewer"
    echo "  • htop - Process viewer"
    echo "  • node/npm/yarn - JavaScript tools"
}

# Function to check if all required tools are installed
check_mac_tools() {
    echo "🔍 Checking required tools..."
    
    local missing_tools=()
    local tools=("eza" "bat" "git" "fzf" "rg" "fd" "jq" "tree" "htop" "node" "npm")
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        else
            echo "✅ $tool - $(command -v "$tool")"
        fi
    done
    
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        echo "🎉 All tools are installed!"
    else
        echo ""
        echo "❌ Missing tools: ${missing_tools[*]}"
        echo "Run 'install_mac_tools' to install missing tools"
    fi
}

# Function to create the fbi (Fast Brew Install) tool

# Function to setup everything
setup_mac_environment() {
    echo "🚀 Setting up macOS development environment..."
    
    install_mac_tools
    check_mac_tools
    
    echo ""
    echo "🎯 Setup complete! Your aliases should now work properly."
    echo "💡 Try these commands:"
    echo "  • ls (uses eza)"
    echo "  • cat <file> (uses bat)"
    echo "  • brewin <package> (uses fbi)"
    echo "  • g (git shortcut)"
}

# Auto-run setup when file is loaded (only once)
if [[ -z "$MAC_ENVIRONMENT_SETUP" ]]; then
    setup_mac_environment
    export MAC_ENVIRONMENT_SETUP="true"
fi

# vim:ft=zsh 