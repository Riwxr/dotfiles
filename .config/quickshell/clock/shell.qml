// quickshell/shell.qml

import QtQuick 2.15
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: clockWindow
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
            mask: Region {}   // click-through


Item {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 40

    property var currentDate: new Date()
    
    Rectangle {
        id: clockFrame
        color: "transparent"
        border.color: "red"
        border.width: 0


Column {
    id: clockColumn
    anchors.fill: parent
    anchors.margins: 0
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: -30

    property var currentDate: new Date()

    Timer {
        interval: 1000     // 1 second
        running: true
        repeat: true
        onTriggered: clockColumn.currentDate = new Date()
    }

    Text {
        text: "- " + Qt.formatDateTime(clockColumn.currentDate, "dddd, MMMM dd") + " -"
        font.family: "ROTHEFIGHT"
        font.pixelSize: 22
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: Qt.formatDateTime(clockColumn.currentDate, "HH:mm")
        font.family: "ROTHEFIGHT"
        font.pixelSize: 210
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}



        // Rectangle shrink-wraps the column content
        width: clockColumn.implicitWidth
        height: clockColumn.implicitHeight

        anchors.horizontalCenter: parent.horizontalCenter
    }
}

       }
    }
}

