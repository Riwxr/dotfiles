function fish_prompt
    # Directory in bold #87FF87
    set_color -o D1D0F8
    echo -n (prompt_pwd)
    set_color normal
    
    # Bold # symbol in #BCBCBC
    set_color -o BCBCBC
    echo -n " # "
    set_color normal
end
