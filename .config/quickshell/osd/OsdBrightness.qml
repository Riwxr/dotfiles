import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Brightness
import Quickshell.Widgets

Scope {
    id: root

    Brightness {
        id: brightness
    }

    property real lastBrightness: 0
    property int direction: 0
    property bool shouldShowOsd: false

    property real currentBrightness: brightness.screenBrightness ?? 0

    onCurrentBrightnessChanged: {
        let current = currentBrightness

        if (current > root.lastBrightness)
            root.direction = 1
        else if (current < root.lastBrightness)
            root.direction = -1

        root.lastBrightness = current
        root.shouldShowOsd = true

        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1200
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.top: true
            anchors.right: true

            margins.top: 8
            margins.right: 114

            exclusiveZone: 0
            color: "transparent"

            implicitWidth: 50
            implicitHeight: 110
            mask: Region {}

            Item {
                anchors.fill: parent

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#161622"

                    border.width: 1
                    border.color: "#494d5d"

                    layer.enabled: true
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 2
                    width: parent.width

                    // TOP
                    Item {
                        width: parent.width
                        height: 20

                        Text {
                            anchors.centerIn: parent
                            text: "▲"
                            visible: root.direction === 1
                            font.pixelSize: 12
                            color: "#e6ffffff"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: Math.round(currentBrightness * 100)
                            visible: root.direction === -1

                            font.pixelSize: 16
                            font.bold: true
                            font.family: "Outfit"
                            color: "white"
                        }
                    }

                    // ICON
                    Item {
                        width: 30
                        height: 30
                        anchors.horizontalCenter: parent.horizontalCenter

                        IconImage {
                            anchors.centerIn: parent
                            implicitSize: 24
                            source: {
                                let b = currentBrightness
                                if (b === 0) return Quickshell.iconPath("display-brightness-off-symbolic")
                                if (b < 0.5) return Quickshell.iconPath("display-brightness-low-symbolic")
                                return Quickshell.iconPath("display-brightness-high-symbolic")
                            }
                        }
                    }

                    // BOTTOM
                    Item {
                        width: parent.width
                        height: 20

                        Text {
                            anchors.centerIn: parent
                            text: "▼"
                            visible: root.direction === -1
                            font.pixelSize: 12
                            color: "#e6ffffff"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: Math.round(currentBrightness * 100)
                            visible: root.direction === 1

                            font.pixelSize: 16
                            font.bold: true
                            font.family: "Outfit"
                            color: "white"
                        }
                    }
                }
            }
        }
    }
}
