# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
   
)

source $ZSH/oh-my-zsh.sh
source /home/jima/.p10k.zsh
# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch moved to top of file before P10k instant prompt to avoid warnings


source "/home/jima/zsh/aliases.zsh"
source "/home/jima/zsh/plugins.zsh"

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
#source <(fzf --zsh)
# Clone the repo into Oh My Zsh themes directory
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
alias aptuin="apt-cache pkgnames | fzf -m --preview 'cat <(apt-cache show {1}) <(apt-file list {1} 2>/dev/null | awk \"{print \$2}\")' | xargs -ro sudo apt install"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# opencode
export PATH=/home/jima/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
