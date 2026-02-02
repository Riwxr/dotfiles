#! /usr/bin/env bash

[[ $1 == c ]] && rmpc clear && rmpc listall | fzf | xargs -I{} rmpc add "{}" ||  rmpc listall | fzf | xargs -I{} rmpc add "{}"
rmpc play
