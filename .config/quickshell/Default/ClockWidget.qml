// ClockWidget.qml
import QtQuick

Rectangle {
    id: background
    color: Qt.rgba(192, 202, 245, 0.08)
    radius: 4

    width: label.contentWidth + 14
    height: label.contentHeight + 3

    Text {
        id: label
        text: Time.time
        font.family: "Outfit"
        font.pixelSize: 15
        font.weight: Font.Bold
        color: "white"
        anchors.centerIn: parent
    }
}
