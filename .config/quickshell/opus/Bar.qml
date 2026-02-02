import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "components"

PanelWindow {
    property var screen
    anchors { top: true; left: true; right: true }
    height: 24
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"

    RowLayout {
        anchors.fill: parent
        spacing: 6

        RowLayout {
            spacing: 6
            Workspaces {}
            Mpris {}
            Submap {}
        }

        Item { Layout.fillWidth: true }
        Clock {}
        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 6
            Bluetooth {}
            Network {}
            Audio {}
            Backlight {}
            Battery {}
        }
    }
}
