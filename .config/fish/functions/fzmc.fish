function fzmc --wraps='rmpc clear ; rmpc listall | fzf | xargs -I{} rmpc add {} ; rmpc play' --description 'alias fzmc rmpc clear ; rmpc listall | fzf | xargs -I{} rmpc add {} ; rmpc play'
    rmpc clear ; rmpc listall | fzf | xargs -I{} rmpc add {} ; rmpc play $argv
end
