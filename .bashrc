# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Load custom aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Todo list all take in order they were created and doesnt conflit while flushing and clearing the console
t() {
    # Archive completed tasks (skip mkdir since folder exists)
    grep -rl "STATUS:COMPLETED" ~/.local/share/calendars/personal 2>/dev/null |
        sort | xargs -r mv -t ~/.local/share/todoman/archive/

    # Flush and list/execute
    command todo flush --yes

    if [ $# -eq 0 ]; then
        clear
        command todo list --sort -created_at
    else
        command todo "$@"
    fi
}

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# NeoVim
export PATH="$PATH:/opt/nvim/"
export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'
alias v='XDG_CONFIG_HOME=$HOME/.config/nvim-fresh XDG_DATA_HOME=$HOME/.local/share/nvim-fresh nvim'
## Bold pastel green prompt with soft white #
PS1="\[\e[1;38;5;189m\]\w\[\e[0m\] \[\e[1;38;5;250m\]#\[\e[0m\] "

bat -p ~/banner6.txt

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
