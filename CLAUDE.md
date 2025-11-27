# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Modular Zsh configuration using Oh My Zsh framework, Zinit plugin manager, and Powerlevel10k theme. Primary platform is Arch Linux with separate macOS configurations available.

## Architecture

The `.zshrc` is symlinked from `~/zsh/.zshrc` to `~/.zshrc` and sources modular configs:

```
.zshrc              → Main entry: loads Oh My Zsh, sources aliases.zsh and plugins.zsh
├── aliases.zsh     → 200+ aliases (git, pacman/paru, system); sources ghpick.zsh
├── plugins.zsh     → Zinit plugin manager with fzf, exa, bat, syntax highlighting
├── ghpick.zsh      → GitHub repository picker using fzf and gh CLI
└── env.zsh         → PATH, XDG directories, tool configs (not currently sourced in .zshrc)
```

For macOS: symlink `mac.zshrc` instead, which uses `mac.aliases.zsh` and `mac.plugins.zsh`.

## Reload After Changes

```bash
source ~/.zshrc   # or use alias: sr
```

## Scripts

### install-apps.sh

Installs AUR packages and restores Zen browser profile:

```bash
~/zsh/scripts/install-apps.sh              # Full install
~/zsh/scripts/install-apps.sh --apps-only  # Skip Zen profile
~/zsh/scripts/install-apps.sh --zen-only   # Skip app install
~/zsh/scripts/install-apps.sh --force      # Overwrite existing Zen profile
```

To add apps, edit the `AUR_APPS` array in the script.

## Key Aliases

| Alias | Command |
|-------|---------|
| `ghin`/`ghpick` | GitHub repo picker with fzf |
| `pacin` | Interactive pacman install |
| `paruin` | Interactive AUR install |
| `pacrem` | Interactive package removal |
| `ls`, `cat` | Replaced with exa, bat |

## Dependencies

Zinit auto-installs itself and plugins on first run. Required tools: `fzf`, `exa`, `bat`, `paru` (AUR), `gh` (GitHub CLI).