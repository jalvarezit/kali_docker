source /root/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom bindkeys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word