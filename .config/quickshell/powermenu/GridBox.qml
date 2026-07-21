// GridBox.qml
import QtQuick 2.15

Rectangle {
    id: box
    width: 150
    height: 125
    color: "#666"
    radius: 3
    border.color: "transparent"
    border.width: 2

    property bool selected: false
    property string label: "Box"
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: box.selected = !box.selected

        onEntered: box.border.color = "white"
        onExited: box.border.color = box.selected ? "yellow" : "transparent"
    }

    // Example content
    Text {
        anchors.centerIn: parent
        text: box.selected ? "Selected" : "Box"
        color: "white"
    }

    Behavior on border.color {
        ColorAnimation { duration: 150 }
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}
