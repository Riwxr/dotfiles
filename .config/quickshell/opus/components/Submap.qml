import QtQuick
import Quickshell
import Quickshell.Hyprland

Text {
    visible: Hyprland.submap !== ""
    text: Hyprland.submap
    font.pixelSize: 14
}
