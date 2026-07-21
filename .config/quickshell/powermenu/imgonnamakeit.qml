import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    mask: Region { item: rect }
    width: 670
    height: 290
    color: Qt.rgba(0,0,0,0)

    Rectangle {
        id: rect
        anchors.fill: parent
        radius: 3

        Grid {
            id: boxGrid
            anchors.centerIn: parent
            columns: 4     // 4 boxes per row
            rowSpacing: 10
            columnSpacing: 10

            Repeater {
                model: 8
                GridBox {
                    label: "Box " + (index + 1)
                }


            }

        }
    }
}
