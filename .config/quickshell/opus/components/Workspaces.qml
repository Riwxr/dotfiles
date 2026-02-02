import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

RowLayout {
    spacing: 2
    Repeater {
        model: HyprlandWorkspaces.workspaces
        delegate: Rectangle {
            required property var modelData
            width: 20; height: 18; radius: 3
            color: modelData.active ? "rgba(136,192,208,0.15)" : "transparent"
            Text {
                anchors.centerIn: parent
                text: modelData.id
                color: modelData.active ? "#88c0d0" : "#B8C1EB"
                font.pixelSize: 14
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }
        }
    }
}
