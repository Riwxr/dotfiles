import QtQuick
import Quickshell
import Quickshell.Services.Backlight

Text {
    property var bl: Backlight.displays[0]
    text: bl ? Math.round(bl.brightness * 100) + "%" : ""
    font.pixelSize: 13
}
