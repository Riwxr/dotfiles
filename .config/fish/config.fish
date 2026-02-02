

if status is-interactive
	set_color $fish_color_keyword -o
	cat -p ~/banner5.txt
	set_color normal
	

    set -U fish_greeting "  "

    set -gx PATH $HOME/.pyenv/bin $PATH


end

if type -q zoxide
    zoxide init fish | source
end

# pyenv init

