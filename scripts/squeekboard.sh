#!/bin/bash

# start squeekboard if not running
pgrep -x squeekboard >/dev/null || squeekboard &

# toggle visibility
current=$(busctl --user get-property sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible | awk '{print $2}')
if [ "$current" = "true" ]; then
    busctl --user call sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
else
    busctl --user call sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
fi

