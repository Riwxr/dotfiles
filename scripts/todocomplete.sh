#! /usr/bin/env bash

sel=$(grep -E '\[ \].{3,}' ~/vimwiki/Todo.md | fzf)
perl -i -pe "s/\Q$sel\E/$sel =~ s/\[ \]/[x]/r/e" ~/vimwiki/Todo.md

