import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Scope {
    id: root

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    property real lastVolume: 0
    property int direction: 0
    property bool shouldShowOsd: false

    property real currentVolume: Pipewire.defaultAudioSink?.audio.volume ?? 0

    onCurrentVolumeChanged: {
        let current = currentVolume

        if (current > root.lastVolume)
            root.direction = 1
        else if (current < root.lastVolume)
            root.direction = -1

        root.lastVolume = current
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

            // compact size
            implicitWidth: 50
            implicitHeight: 110
            mask: Region {}

            Item {
                anchors.fill: parent

                // dark bluish glass
                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: "#161622"   // dark bluish tone
    border.width: 1
    border.color: "#494d5d"   // soft bluish glow

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
                            text: Math.round(currentVolume * 100)
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
                                let v = currentVolume
                                if (v === 0) return Quickshell.iconPath("audio-volume-muted-symbolic")
                                if (v < 0.5) return Quickshell.iconPath("audio-volume-low-symbolic")
                                return Quickshell.iconPath("audio-volume-high-symbolic")
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
                            text: Math.round(currentVolume * 100)
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
