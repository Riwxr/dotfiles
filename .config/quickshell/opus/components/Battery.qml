import QtQuick
import Quickshell
import Quickshell.Services.UPower

Text {
    property var bat: UPower.displayDevice
    text: Math.round(bat.percentage) + "%"
    color: bat.charging ? "#7dcfff" : "#9ece6a"
    font.pixelSize: 13
}
