import QtQuick
import Quickshell
import Quickshell.Services.Bluetooth

Text {
    visible: Bluetooth.devices.some(d => d.connected)
    text: "󰂯"
    font.pixelSize: 16
}
