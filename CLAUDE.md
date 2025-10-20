# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a modular Zsh configuration repository that uses Oh My Zsh and Zinit for plugin management. The configuration is split into multiple files for better organization and maintainability.

## Architecture

The configuration follows a modular approach where the main `.zshrc` sources individual configuration files from the `zsh/` directory:

- **Main entry**: `.zshrc` - Sources Oh My Zsh and loads modular configs
- **Aliases**: `aliases.zsh` - Contains extensive git and system aliases  
- **Plugins**: `plugins.zsh` - Manages Zinit plugins including fzf, exa, bat
- **Environment**: `env.zsh` - Sets PATH, XDG directories, and tool configurations
- **GitHub tool**: `ghpick.zsh` - Custom GitHub repository picker using fzf

## Key Dependencies

- **Oh My Zsh**: Framework loaded from `$HOME/.oh-my-zsh`
- **Zinit**: Plugin manager for loading zsh plugins
- **Tools**: fzf, exa, bat, ranger, paru (AUR helper), fastfetch
- **Theme**: agnosterzak (Oh My Zsh theme)

## Common Development Tasks

```bash
# Source the zsh configuration after changes
source ~/.zshrc

# Or use the alias
sr

# Test GitHub repository picker
ghpick
# Or use the alias
ghin
```

## Git Workflow

The repository includes extensive git aliases. Key ones:
- `gcam` - Commit all with message
- `gst` - Git status  
- `gd` - Git diff
- `gl` - Git pull
- `gp` - Git push

## Platform-Specific Files

- `mac.aliases.zsh` - macOS specific aliases
- `mac.plugins.zsh` - macOS specific plugins  
- `mac.zshrc` - macOS specific zshrc

The main configuration appears to be for Arch Linux (uses pacman/paru).