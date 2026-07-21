// Launcher.qml
// ─────────────────────────────────────────────────────────────────────────────
// Centered popup launcher for Quickshell (Wayland / wlr-layer-shell).
//
// Extending:
//   Add / remove entries in the `launcherItems` ListModel.
//   Each entry: icon (Nerd Font char), label, command (run via bash -c).
// ─────────────────────────────────────────────────────────────────────────────

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: root

    // ── Window / layer-shell setup ───────────────────────────────────────────
    visible: false
    color: "transparent"

    WlrLayershell.layer:        WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.exclusiveZone: -1

    // Stretch across the full screen so we can centre our card ourselves
    anchors {
        top:    true
        bottom: true
        left:   true
        right:  true
    }

    // ── Public API ───────────────────────────────────────────────────────────
    function show() {
        confirmState = false
        pendingIndex = -1
        root.visible = true
        gridView.currentIndex = 0
        gridView.forceActiveFocus()
    }

    function hide() {
        root.visible = false
        confirmState = false
        pendingIndex  = -1
    }

    // ── Internal state ───────────────────────────────────────────────────────
    property bool confirmState: false
    property int  pendingIndex: -1

    // ── Item data ────────────────────────────────────────────────────────────
    ListModel {
        id: launcherItems

        // Row 1
        ListElement { icon: "\uf011"; label: "Power Off";  command: "systemctl poweroff"          }
        ListElement { icon: "\uf021"; label: "Reboot";     command: "systemctl reboot"             }
        ListElement { icon: "\uf28b"; label: "Suspend";    command: "systemctl suspend"            }
        ListElement { icon: "\uf236"; label: "Hibernate";  command: "systemctl hibernate"          }
        // Row 2
        ListElement { icon: "\uf023"; label: "Lock";       command: "hyprlock"                     }
        ListElement { icon: "\uf2f5"; label: "Logout";     command: "hyprctl dispatch exit 0"      }
        ListElement { icon: "\uf120"; label: "Terminal";   command: "foot"                         }
        ListElement { icon: "\uf07b"; label: "Files";      command: "thunar"                       }
    }

    // ── Process helper (runs commands) ───────────────────────────────────────
    Process {
        id: proc
        command: ["bash", "-c", ""]
    }

    function runCommand(cmd) {
        proc.command = ["bash", "-c", cmd]
        proc.start()
    }

    // ── Dim overlay ──────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color:   "#000000"
        opacity: root.visible ? 0.70 : 0

        Behavior on opacity {
            NumberAnimation { duration: 180; easing.type: Easing.InOutQuad }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.hide()
        }
    }

    // ── Centre anchor ────────────────────────────────────────────────────────
    Item {
        anchors.centerIn: parent
        width:  Math.max(mainCard.width,  confirmCard.width)
        height: Math.max(mainCard.height, confirmCard.height)

        // ── Main grid card ───────────────────────────────────────────────────
        Rectangle {
            id: mainCard

            readonly property int columns:     4
            readonly property int cellSz:      96
            readonly property int cellGap:     14
            readonly property int pad:         28
            readonly property int headerH:     44

            width:  columns * cellSz + (columns - 1) * cellGap + 2 * pad
            height: Math.ceil(launcherItems.count / columns) * cellSz
                    + (Math.ceil(launcherItems.count / columns) - 1) * cellGap
                    + 2 * pad + headerH

            anchors.centerIn: parent

            color:        "#090909"
            border.color: "#ffffff"
            border.width: 1
            radius:       4

            visible: !root.confirmState
            opacity: visible ? 1 : 0
            scale:   visible ? 1 : 0.93

            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
            Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }

            // Header
            Text {
                id: headerTxt
                anchors {
                    top:              parent.top
                    topMargin:        mainCard.pad
                    horizontalCenter: parent.horizontalCenter
                }
                text:  "LAUNCH"
                color: "#ffffff"
                font {
                    family:        "JetBrainsMono Nerd Font"
                    pixelSize:     12
                    letterSpacing: 6
                    weight:        Font.Light
                }
            }

            Rectangle {
                id: divider
                anchors {
                    top:         headerTxt.bottom
                    topMargin:   10
                    left:        parent.left
                    right:       parent.right
                    leftMargin:  mainCard.pad
                    rightMargin: mainCard.pad
                }
                height: 1
                color:  "#222222"
            }

            // Grid
            GridView {
                id: gridView

                anchors {
                    top:        divider.bottom
                    topMargin:  mainCard.pad * 0.6
                    left:       parent.left
                    right:      parent.right
                    bottom:     parent.bottom
                    margins:    mainCard.pad
                }

                cellWidth:  mainCard.cellSz + mainCard.cellGap
                cellHeight: mainCard.cellSz + mainCard.cellGap

                model: launcherItems
                clip:  false
                focus: true

                Keys.onPressed: (event) => {
                    // Escape
                    if (event.key === Qt.Key_Escape) {
                        root.hide()
                        event.accepted = true
                        return
                    }
                    // Number keys 1–8
                    const n = event.key - Qt.Key_1
                    if (n >= 0 && n < launcherItems.count) {
                        gridView.currentIndex = n
                        root.requestConfirm(n)
                        event.accepted = true
                        return
                    }
                    // Enter / Space
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                        root.requestConfirm(gridView.currentIndex)
                        event.accepted = true
                    }
                }
                Keys.onLeftPressed:  if (currentIndex > 0)
                                         currentIndex--
                Keys.onRightPressed: if (currentIndex < count - 1)
                                         currentIndex++
                Keys.onUpPressed:    if (currentIndex >= mainCard.columns)
                                         currentIndex -= mainCard.columns
                Keys.onDownPressed:  if (currentIndex + mainCard.columns < count)
                                         currentIndex += mainCard.columns

                delegate: Item {
                    id: cellItem
                    width:  mainCard.cellSz
                    height: mainCard.cellSz

                    readonly property bool isCurrent: GridView.isCurrentItem
                    readonly property bool isHovered: cellMouse.containsMouse

                    onIsHoveredChanged: {
                        if (isHovered) gridView.currentIndex = index
                    }

                    Rectangle {
                        anchors.fill: parent
                        color:        cellItem.isCurrent ? "#111111" : "#000000"
                        border.color: cellItem.isCurrent ? "#ffffff"  : "#252525"
                        border.width: 1
                        radius:       3
                        scale:        cellItem.isCurrent ? 1.06 : 1.0

                        Behavior on scale        { NumberAnimation { duration: 110; easing.type: Easing.OutQuad } }
                        Behavior on color        { ColorAnimation  { duration: 100 } }
                        Behavior on border.color { ColorAnimation  { duration: 100 } }

                        Column {
                            anchors.centerIn: parent
                            spacing: 7

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text:  model.icon
                                color: cellItem.isCurrent ? "#ffffff" : "#777777"
                                font  { family: "JetBrainsMono Nerd Font"; pixelSize: 28 }
                                Behavior on color { ColorAnimation { duration: 100 } }
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text:  model.label
                                color: cellItem.isCurrent ? "#cccccc" : "#444444"
                                font  {
                                    family:        "JetBrainsMono Nerd Font"
                                    pixelSize:     10
                                    letterSpacing: 1.5
                                    weight:        Font.Light
                                }
                                Behavior on color { ColorAnimation { duration: 100 } }
                            }
                        }

                        // Corner index hint
                        Text {
                            anchors { top: parent.top; left: parent.left; margins: 5 }
                            text:  (index + 1).toString()
                            color: cellItem.isCurrent ? "#555555" : "#252525"
                            font  { family: "JetBrainsMono Nerd Font"; pixelSize: 9 }
                            Behavior on color { ColorAnimation { duration: 100 } }
                        }
                    }

                    MouseArea {
                        id: cellMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked:    root.requestConfirm(index)
                    }
                }
            }
        }

        // ── Confirmation card ────────────────────────────────────────────────
        Rectangle {
            id: confirmCard

            width:  300
            height: 140
            anchors.centerIn: parent

            color:        "#090909"
            border.color: "#ffffff"
            border.width: 1
            radius:       4

            visible: root.confirmState
            opacity: visible ? 1 : 0
            scale:   visible ? 1 : 0.90

            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
            Behavior on scale   { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }

            focus: root.confirmState

            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Y) {
                    root.executeCommand(); event.accepted = true
                } else if (event.key === Qt.Key_Escape || event.key === Qt.Key_N) {
                    root.cancelConfirm();  event.accepted = true
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.pendingIndex >= 0
                          ? "Run \u2018" + launcherItems.get(root.pendingIndex).label + "\u2019?"
                          : ""
                    color: "#ffffff"
                    font  {
                        family:        "JetBrainsMono Nerd Font"
                        pixelSize:     13
                        letterSpacing: 1.5
                        weight:        Font.Light
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 14

                    LauncherButton {
                        btnLabel: "YES"
                        isPrimary: true
                        onActivated: root.executeCommand()
                    }

                    LauncherButton {
                        btnLabel: "NO"
                        isPrimary: false
                        onActivated: root.cancelConfirm()
                    }
                }
            }
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────
    function requestConfirm(idx) {
        pendingIndex = idx
        confirmState = true
        confirmCard.forceActiveFocus()
    }

    function cancelConfirm() {
        confirmState = false
        pendingIndex  = -1
        gridView.forceActiveFocus()
    }

    function executeCommand() {
        if (pendingIndex < 0) return
        runCommand(launcherItems.get(pendingIndex).command)
        root.hide()
    }

    // ── Inline sub-component: button ─────────────────────────────────────────
    component LauncherButton: Rectangle {
        id: lbtn

        property string  btnLabel:   "OK"
        property bool    isPrimary:  false

        signal activated

        width:  100
        height: 32
        radius: 3

        color: mouse.containsMouse
               ? (isPrimary ? "#ffffff" : "#1c1c1c")
               : "#000000"
        border.color: isPrimary ? "#ffffff" : "#333333"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 90 } }

        Text {
            anchors.centerIn: parent
            text:  lbtn.btnLabel
            color: (mouse.containsMouse && lbtn.isPrimary) ? "#000000" : "#ffffff"
            font  {
                family:        "JetBrainsMono Nerd Font"
                pixelSize:     11
                letterSpacing: 3
                weight:        Font.Medium
            }
            Behavior on color { ColorAnimation { duration: 90 } }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked:    lbtn.activated()
        }
    }
}
