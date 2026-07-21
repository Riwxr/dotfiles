function mann --wraps=man --description 'passes man through bat'
    man $argv | bat -l man --wrap=auto
end
