function fzcd --wraps='~/scripts/compgenfzf.sh | fzf | xargs man' --wraps='~/scripts/compgenfzf.sh | fzf | xargs man || help xargs' --wraps='~/scripts/compgenfzf.sh | fzf | man xargs || help xargs' --description 'alias fzcd ~/scripts/compgenfzf.sh | fzf | man xargs || help xargs'
    ~/scripts/compgenfzf.sh | fzf | man xargs || help xargs $argv
end
