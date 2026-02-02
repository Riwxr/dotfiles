#!/usr/bin/env bash
set -e

BASE="$HOME/.config/quickshell/opus"
COMP="$BASE/components"

mkdir -p "$COMP"

write() {
  mkdir -p "$(dirname "$1")"
  cat > "$1"
}

write "$BASE/shell.qml" << 'QML'
import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar { screen: modelData }
        }
    }
}
QML

write "$BASE/Bar.qml" << 'QML'
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
QML

write "$COMP/Workspaces.qml" << 'QML'
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
QML

write "$COMP/Clock.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Services.SystemClock

Rectangle {
    height: 20; radius: 3
    color: "rgba(57,75,107,0.4)"
    SystemClock { id: clock; precision: SystemClock.Minutes }
    Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.time, "HH:mm")
        color: "#B9C3ED"
        font.pixelSize: 15
    }
}
QML

write "$COMP/Battery.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Text {
    property var bat: UPower.displayDevice
    text: Math.round(bat.percentage) + "%"
    color: bat.charging ? "#7dcfff" : "#9ece6a"
    font.pixelSize: 13
}
QML

write "$COMP/Network.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Services.NetworkManager

Text {
    text: NetworkManager.wifi?.connected ? "󰤨" : "󰤭"
    font.pixelSize: 13
}
QML

write "$COMP/Audio.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Text {
    property var sink: Pipewire.defaultAudioSink
    text: sink && !sink.muted ? Math.round(sink.volume * 100) + "%" : "MUTE"
    font.pixelSize: 13
}
QML

write "$COMP/Backlight.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Services.Backlight

Text {
    property var bl: Backlight.displays[0]
    text: bl ? Math.round(bl.brightness * 100) + "%" : ""
    font.pixelSize: 13
}
QML

write "$COMP/Bluetooth.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Services.Bluetooth

Text {
    visible: Bluetooth.devices.some(d => d.connected)
    text: "󰂯"
    font.pixelSize: 16
}
QML

write "$COMP/Mpris.qml" << 'QML'
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

RowLayout {
    visible: MprisPlayer.players.length > 0
    Text {
        text: MprisPlayer.players[0]?.metadata?.title || "no media"
        font.pixelSize: 13
    }
}
QML

write "$COMP/Submap.qml" << 'QML'
import QtQuick
import Quickshell
import Quickshell.Hyprland

Text {
    visible: Hyprland.submap !== ""
    text: Hyprland.submap
    font.pixelSize: 14
}
QML

echo "✅ QuickShell Opus installed at $BASE"
