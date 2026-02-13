function v
    set -x XDG_CONFIG_HOME $HOME/.config/nvim-fresh
    set -x XDG_DATA_HOME   $HOME/.local/share/nvim-fresh
    set -x XDG_CACHE_HOME  $HOME/.cache/nvim-fresh
    nvim $argv
end

