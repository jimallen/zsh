# Zsh Configuration

A modular Zsh configuration with Oh My Zsh, Zinit plugin manager, and extensive customizations for Arch Linux and macOS.

## Features

- 🚀 **Oh My Zsh** framework with agnosterzak theme
- 📦 **Zinit** plugin manager for fast plugin loading
- 🔍 **FZF** integration for fuzzy finding
- 🎨 **Enhanced tools**: exa (ls replacement), bat (cat replacement), fastfetch
- 🐙 **Extensive Git aliases** for improved workflow
- 🔧 **Modular configuration** split into logical files
- 🖥️ **Platform-specific** configurations for Linux and macOS

## Prerequisites

- Zsh shell
- Git
- [Oh My Zsh](https://ohmyzsh.sh/)

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/jimallen/zsh.git ~/zsh
```

### 2. Create symlink to .zshrc

```bash
# Backup existing .zshrc if it exists
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

# Create symlink from the repository to your home directory
ln -sf ~/zsh/.zshrc ~/.zshrc
```

### 3. Install Oh My Zsh (if not already installed)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 4. Source the configuration

```bash
source ~/.zshrc
```

Zinit will automatically install itself and the configured plugins on first run.

## Structure

```
zsh/
├── .zshrc              # Main configuration file (symlink this to ~/)
├── aliases.zsh         # System and git aliases
├── env.zsh            # Environment variables and PATH
├── plugins.zsh        # Zinit plugin configurations
├── ghpick.zsh         # GitHub repository picker tool
├── mac.aliases.zsh    # macOS specific aliases
├── mac.plugins.zsh    # macOS specific plugins
├── mac.zshrc          # macOS specific configuration
└── scripts/
    ├── install-apps.sh        # Application installer script
    └── zen-essentials.tar.gz  # Zen browser profile backup
```

## Configuration Files

- **`.zshrc`**: Main entry point that loads Oh My Zsh and sources modular configs
- **`aliases.zsh`**: Contains 200+ aliases for git, pacman/paru (Arch), and common commands
- **`plugins.zsh`**: Manages Zinit plugins including syntax highlighting, autosuggestions, fzf-tab
- **`env.zsh`**: Sets up PATH, XDG directories, default applications, and tool configurations
- **`ghpick.zsh`**: Custom GitHub repository browser and cloner using fzf

## Key Features

### GitHub Repository Picker

Quick access to your GitHub repositories:

```bash
ghpick  # or use alias: ghin
```

### Enhanced Commands

- `ls` → `exa` with icons
- `cat` → `bat` with syntax highlighting
- `cd ..` → `..`
- `clear` → `c`
- `exit` → `q`

### Arch Linux Integration

- `pacin` - Interactive package installation with fzf
- `paruin` - AUR package installation with preview
- `pacrem` - Interactive package removal
- `cleanpac` - Clean orphaned packages

### Git Workflow

Common git operations are shortened:
- `gst` - git status
- `gcam "message"` - commit all with message
- `gd` - git diff
- `gl` - git pull
- `gp` - git push
- `gco` - git checkout
- Plus 150+ more git aliases

## Scripts

### Application Installer (`scripts/install-apps.sh`)

A maintainable script for setting up a new Arch Linux system with Zsh configuration, essential applications, and Zen browser profile.

#### Installed Applications

- `google-chrome` - Google Chrome browser
- `slack-desktop` - Slack messaging app
- `wasistlos` - WhatsApp desktop client
- `claude-desktop-native` - Claude AI desktop app
- `github-cli` - GitHub CLI tool
- `zen-browser-bin` - Zen browser

#### Usage

```bash
# Full setup: apps, Zsh config, and Zen profile
~/zsh/scripts/install-apps.sh

# Install apps only
~/zsh/scripts/install-apps.sh --apps-only

# Setup Zsh only (Oh My Zsh, Powerlevel10k, symlinks)
~/zsh/scripts/install-apps.sh --zsh-only

# Restore Zen profile only
~/zsh/scripts/install-apps.sh --zen-only

# Force overwrite existing files (backs up existing)
~/zsh/scripts/install-apps.sh --force

# Show help
~/zsh/scripts/install-apps.sh --help
```

#### Zsh Setup

The `--zsh-only` option (or full setup) will:
- Install Oh My Zsh if not present
- Install Powerlevel10k theme
- Symlink `.zshrc` → `~/zsh/.zshrc`
- Symlink `.p10k.zsh` → `~/zsh/.p10k.zsh`

#### Adding New Applications

Edit `scripts/install-apps.sh` and add packages to the `AUR_APPS` array:

```bash
AUR_APPS=(
    "google-chrome"
    "slack-desktop"
    "your-new-app"  # Add here
)
```

#### Zen Browser Profile

The script includes a backup of Zen browser essentials:
- Bookmarks and history (`places.sqlite`)
- Settings (`prefs.js`)
- Logins and certificates
- Session data (pinned tabs, workspaces)
- Keyboard shortcuts and themes

**Note:** Extensions are not included in the backup and will need to be reinstalled on first launch.

## Customization

### Adding Custom Configurations

Create new `.zsh` files in the `zsh/` directory and source them in `.zshrc`:

```bash
# In .zshrc, add your file to the sourcing loop
while read file
do 
  source "zsh/$file.zsh"
done <<-EOF
aliases
plugins
your-custom-file  # Add here without .zsh extension
EOF
```

### Platform-Specific Setup

For macOS users, you can use the macOS-specific configuration:

```bash
ln -sf ~/zsh/mac.zshrc ~/.zshrc
```

## Troubleshooting

### Reload Configuration

After making changes:

```bash
source ~/.zshrc
# or use the alias
sr
```

### Missing Commands

Some aliases depend on specific tools:
- Arch Linux: `pacman`, `paru`
- Tools: `fzf`, `exa`, `bat`, `ranger`, `fastfetch`
- GitHub CLI: `gh`

Install missing dependencies as needed.

## License

Feel free to use and modify as needed.

## Contributing

Pull requests are welcome. For major changes, please open an issue first.