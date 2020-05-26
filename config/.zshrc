# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dmrubin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#ssh-agent 
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent`
    ssh-add
fi

# Init SCM Breeze
[ -s "/home/dmrubin/.scm_breeze/scm_breeze.sh" ] && source "/home/dmrubin/.scm_breeze/scm_breeze.sh"

# fzf fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# These write shell history after running a command and makes history
# available to new shells when they run history.
# This does not make that history available to C-r
setopt inc_append_history
setopt share_history

# ls colors
. "/home/dmrubin/.local/share/lscolors.sh"

# zsh terminal completions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# QOL aliases
alias ls="ls -lAGFh --color=always"
# Cause I have fat fingers
alias cd..='cd ..'
alias pyhton='python'
alias pyhton3='pyhton3'
alias ipyhton='ipython'

#Set debugger for breakpoint()
export PYTHONBREAKPOINT=ipdb.set_trace