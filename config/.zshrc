# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source $HOME/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

#ssh-agent 
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent`
    ssh-add
fi

# fzf fuzzy search
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# These write shell history after running a command and makes history
# available to new shells when they run history.
# This does not make that history available to C-r
setopt inc_append_history
setopt share_history

if [[ $(uname) == Darwin ]]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

# ls colors
# if [[ ! $(uname) == Darwin ]]; then
. "$HOME/.local/share/lscolors.sh"
# fi

# zsh terminal completions
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# poetry
source $HOME/.poetry/env

# QOL aliases
alias ls="ls -lAGFh --color=always"

# Cause I have fat fingers
alias cd..='cd ..'
alias pyhton='python'
alias pyhton3='pyhton3'
alias ipyhton='ipython'

#Set debugger for breakpoint()
export PYTHONBREAKPOINT=ipdb.set_trace

# Init SCM Breeze
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"