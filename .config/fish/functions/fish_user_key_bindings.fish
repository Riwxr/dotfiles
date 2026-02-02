function fish_user_key_bindings
    bind \ev __toggle_nvim
    bind \ex __clear_commandline
    bind \ey __toggle_wlcopy
end

function __clear_commandline
    commandline -r ''
end

function __toggle_wlcopy
    set cmd (commandline)

    # Pull from history if empty
    if test -z "$cmd"
        set cmd (history --max=1)
    end

    if test -z "$cmd"
        return
    end

    # Toggle behavior
    if string match -rq '\|\s*wl-copy$' -- $cmd
        # Remove wl-copy
        set cmd (string replace -r '\s*\|\s*wl-copy$' '' -- $cmd)
    else
        # Add wl-copy
        set cmd "$cmd | wl-copy"
    end

    commandline -r $cmd
end

function __toggle_nvim
    set cmd (commandline)

    # If buffer empty, pull last command
    if test -z "$cmd"
        set cmd (history --max=1)
    end

    if test -z "$cmd"
        return
    end

    # Toggle nvim
    if string match -rq '^nvim\s+' -- $cmd
        set cmd (string replace -r '^nvim\s+' '' -- $cmd)
    else
        set cmd "nvim $cmd"
    end

    commandline -r $cmd
end
