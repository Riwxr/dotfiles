import QtQuick
import Quickshell
import Quickshell.Services.SystemClock

Rectangle {
    height: 20; radius: 3
    color: "rgba(57,75,107,0.4)"
    SystemClock { id: clock; precision: SystemClock.Minutes }
    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.time, "HH:mm")
        color: "#B9C3ED"
        font.pixelSize: 15
    }
}
