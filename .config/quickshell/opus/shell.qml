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
