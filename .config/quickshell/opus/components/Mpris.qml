import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

RowLayout {
    visible: MprisPlayer.players.length > 0
    Text {
        text: MprisPlayer.players[0]?.metadata?.title || "no media"
        font.pixelSize: 13
    }
}
