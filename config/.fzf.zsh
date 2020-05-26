# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dmrubin/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/dmrubin/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/dmrubin/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/dmrubin/.fzf/shell/key-bindings.zsh"
