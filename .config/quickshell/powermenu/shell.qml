import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io


PanelWindow {
    id: root

    visible: true
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.exclusiveZone: -1

anchors {
    top: true
    bottom: true
    left: true
    right: true
}

    property bool confirmState: false
    property int pendingIndex: -1

    function show() {
        confirmState = false
        pendingIndex = -1
        visible = true
        grid.currentIndex = 0
        Qt.callLater(() => grid.forceActiveFocus())
    }

    function hide() {
        visible = false
        confirmState = false
        pendingIndex = -1
    }

    function requestConfirm(i) {
        if (confirmState) return
        pendingIndex = i
        confirmState = true
    }

    function cancelConfirm() {
        confirmState = false
        pendingIndex = -1
        Qt.callLater(() => grid.forceActiveFocus())
    }

    function execute() {
        if (pendingIndex < 0) return
        proc.command = ["bash", "-c", model.get(pendingIndex).command]
        proc.start()
        hide()
    }

    Process { id: proc }

    ListModel {
        id: model
        ListElement { icon: "\uf011"; label: "Power";    command: "systemctl poweroff" }
        ListElement { icon: "\uf021"; label: "Reboot";   command: "systemctl reboot" }
        ListElement { icon: "\uf28b"; label: "Suspend";  command: "systemctl suspend" }
        ListElement { icon: "\uf236"; label: "Hibernate";command: "systemctl hibernate" }
        ListElement { icon: "\uf023"; label: "Lock";     command: "hyprlock" }
        ListElement { icon: "\uf2f5"; label: "Logout";   command: "hyprctl dispatch exit 0" }
        ListElement { icon: "\uf120"; label: "Term";     command: "foot" }
        ListElement { icon: "\uf07b"; label: "Files";    command: "thunar" }
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: root.visible ? 0.7 : 0

        Behavior on opacity { NumberAnimation { duration: 150 } }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!main.containsMouse && !confirm.containsMouse)
                    root.hide()
            }
        }
    }

    Item {
        anchors.centerIn: parent

        // MAIN GRID
        Rectangle {
            id: main
            visible: !root.confirmState
            opacity: visible ? 1 : 0
            scale: visible ? 1 : 0.95

            Behavior on opacity { NumberAnimation { duration: 120 } }
            Behavior on scale { NumberAnimation { duration: 120 } }

            property int cols: 4
            property int size: 90
            property int gap: 12
            property int pad: 24

            width: cols * size + (cols - 1) * gap + pad * 2
            height: Math.ceil(model.count / cols) * size +
                    (Math.ceil(model.count / cols) - 1) * gap + pad * 2

            color: "#090909"
            border.color: "#ffffff"
            border.width: 1
            radius: 4

            GridView {
                id: grid
                anchors.fill: parent
                anchors.margins: main.pad

                cellWidth: main.size + main.gap
                cellHeight: main.size + main.gap

                model: model
                focus: true

                Keys.onPressed: (e) => {
                    if (e.key === Qt.Key_Escape) root.hide()

                    let n = e.key - Qt.Key_1
                    if (n >= 0 && n < model.count) {
                        currentIndex = n
                        root.requestConfirm(n)
                    }

                    if (e.key === Qt.Key_Return || e.key === Qt.Key_Space)
                        root.requestConfirm(currentIndex)
                }

                Keys.onLeftPressed: {
                    if (currentIndex % main.cols !== 0) currentIndex--
                }
                Keys.onRightPressed: {
                    if ((currentIndex + 1) % main.cols !== 0 && currentIndex < count - 1)
                        currentIndex++
                }
                Keys.onUpPressed: {
                    if (currentIndex >= main.cols) currentIndex -= main.cols
                }
                Keys.onDownPressed: {
                    if (currentIndex + main.cols < count) currentIndex += main.cols
                }

                delegate: Rectangle {
                    width: main.size
                    height: main.size

                    property bool active: GridView.isCurrentItem

                    color: active ? "#0f0f0f" : "#000000"
                    border.color: active ? "#ffffff" : "#1a1a1a"
                    border.width: 1
                    radius: 3

                    scale: active ? 1.04 : 1.0
                    transformOrigin: Item.Center

                    Behavior on scale { NumberAnimation { duration: 100 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: model.icon
                            color: active ? "#ffffff" : "#666666"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 26
                        }

                        Text {
                            text: model.label
                            color: active ? "#cccccc" : "#444444"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: grid.currentIndex = index
                        onClicked: root.requestConfirm(index)
                    }
                }
            }
        }

        // CONFIRM
        Rectangle {
            id: confirm
            visible: root.confirmState
            opacity: visible ? 1 : 0
            scale: visible ? 1 : 0.95

            Behavior on opacity { NumberAnimation { duration: 120 } }
            Behavior on scale { NumberAnimation { duration: 120 } }

            width: 280
            height: 130

            color: "#090909"
            border.color: "#ffffff"
            border.width: 1
            radius: 4

            onVisibleChanged: {
                if (visible)
                    Qt.callLater(() => confirm.forceActiveFocus())
            }

            Keys.onPressed: (e) => {
                if (e.key === Qt.Key_Return || e.key === Qt.Key_Y)
                    root.execute()
                if (e.key === Qt.Key_Escape || e.key === Qt.Key_N)
                    root.cancelConfirm()
            }

            Column {
                anchors.centerIn: parent
                spacing: 18

                Text {
                    text: root.pendingIndex >= 0
                          ? "Run " + model.get(root.pendingIndex).label + "?"
                          : ""
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                }

                Row {
                    spacing: 12
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 90; height: 30
                        color: "#000000"
                        border.color: "#ffffff"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "YES"
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.execute()
                        }
                    }

                    Rectangle {
                        width: 90; height: 30
                        color: "#000000"
                        border.color: "#333333"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "NO"
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.cancelConfirm()
                        }
                    }
                }
            }
        }
    }
}
