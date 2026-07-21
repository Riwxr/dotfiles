import QtQuick 2.15
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            property var modelData
            screen: modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            mask: Region {}

            Text {
                id: tinyTime
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 10
                anchors.bottomMargin: 10
                text: Qt.formatDateTime(new Date(), "HH:mm")
                font.family: "Outfit"
                font.pixelSize: 14
                color: Qt.rgba(1, 1, 1, 0.20)

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: tinyTime.text = Qt.formatDateTime(new Date(), "HH:mm")
                }
            }
        }
    }
}
