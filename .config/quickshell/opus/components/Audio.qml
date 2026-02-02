import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Text {
    property var sink: Pipewire.defaultAudioSink
    text: sink && !sink.muted ? Math.round(sink.volume * 100) + "%" : "MUTE"
    font.pixelSize: 13
}
