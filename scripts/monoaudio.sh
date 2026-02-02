
#!/bin/bash

# Names of sinks
MONO_SINK_NAME="mono"
DEFAULT_SINK=$(pactl info | grep "Default Sink" | awk '{print $3}')
STEREO_SINK="alsa_output.pci-0000_00_1f.3"  # replace with your stereo sink

# Check if mono sink exists
if pactl list short sinks | grep -q "$MONO_SINK_NAME"; then
    # Mono exists, switch back to stereo
    pactl set-default-sink $STEREO_SINK
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input $input $STEREO_SINK
    done
    # Unload mono module
    MODULE_INDEX=$(pactl list short modules | grep "$MONO_SINK_NAME" | awk '{print $1}')
    pactl unload-module $MODULE_INDEX
    notify-send "Audio switched back to stereo."
else
    # Mono does not exist, create it
    MODULE_INDEX=$(pactl load-module module-remap-sink master=$STEREO_SINK sink_name=$MONO_SINK_NAME channels=1 channel_map=mono)
    pactl set-default-sink $MONO_SINK_NAME
    for input in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input $input $MONO_SINK_NAME
    done
    notify-send "Audio is now in mono."
fi

