function fzm --wraps='rmpc listall | fzf | xargs -I{} rmpc add {}' --wraps='rmpc listall | fzf | xargs -I{} rmpc add {} ; rmpc play' --description 'alias fzm rmpc listall | fzf | xargs -I{} rmpc add {} ; rmpc play'
    rmpc listall | fzf | xargs -I{} rmpc add {} ; rmpc play $argv
end
