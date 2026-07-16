
if status is-interactive

    set -U fish_greeting '  ▘       
▛▘▌▌▌▌▚▘▛▘
▌ ▌▚▚▘▞▖▌ 
'

    set_color normal
    set_color $fish_color_keyword -o
    set -gx PATH $HOME/.pyenv/bin $PATH
set -x PYTHONPATH $HOME/RealtimeSTT $PYTHONPATH

end

if type -q zoxide
    zoxide init fish | source
end

# pyenv init

