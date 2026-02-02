// Bar.qml
import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      color: "transparent"
      implicitHeight: 24

      Item {
        anchors.fill: parent
        anchors.topMargin: 1

        ClockWidget {
          anchors.centerIn: parent
        }
      }
    }
  }
}

