import QtQuick
import Quickshell
import Quickshell.Services.NetworkManager

Text {
    text: NetworkManager.wifi?.connected ? "󰤨" : "󰤭"
    font.pixelSize: 13
}
