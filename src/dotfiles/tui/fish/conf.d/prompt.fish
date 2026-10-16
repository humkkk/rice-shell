status is-interactive; or return

# Starship
command -v starship &> /dev/null && starship init fish | source

# Direnv + Zoxide
command -v direnv &> /dev/null && direnv hook fish | source
command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

# Better ls
command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'
