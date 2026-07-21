import QtQuick 2.15
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: dotsWindow
            property var modelData
            screen: modelData
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Bottom
            mask: Region {}

            Pips {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
            }
        }
    }
}
